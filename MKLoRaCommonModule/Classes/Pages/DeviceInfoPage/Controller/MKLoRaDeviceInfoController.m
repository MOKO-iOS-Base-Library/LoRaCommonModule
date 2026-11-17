//
//  MKLoRaDeviceInfoController.m
//  MKLoRaCommonModule
//
//  Created by aa on 2025/xx/xx.
//

#import "MKLoRaDeviceInfoController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"
#import "MKNormalTextCell.h"
#import "MKTableSectionLineHeader.h"

@interface MKLoRaDeviceInfoController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) MKBaseTableView *tableView;

@property (nonatomic, strong) NSMutableArray *section0List;   // Software
@property (nonatomic, strong) NSMutableArray *section1List;   // Firmware
@property (nonatomic, strong) NSMutableArray *section2List;   // Hardware
@property (nonatomic, strong) NSMutableArray *section3List;   // Battery Voltage
@property (nonatomic, strong) NSMutableArray *section4List;   // MAC / Product / Manufacture
@property (nonatomic, strong) NSMutableArray *section5List;   // Battery Consumption (optional)
@property (nonatomic, strong) NSMutableArray *section6List;   // Debugger Mode (optional)

@property (nonatomic, strong) NSMutableArray *headerList;

/// 进入 DFU 页面返回后不再读取数据
@property (nonatomic, assign) BOOL isDfuModel;

@end

@implementation MKLoRaDeviceInfoController

- (void)dealloc {
    NSLog(@"MKLoRaDeviceInfoController销毁");
    if ([self.protocol respondsToSelector:@selector(deviceInfoPageShouldObserveDFUNotification)] &&
        [self.protocol deviceInfoPageShouldObserveDFUNotification]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.isDfuModel) {
        [self readDataFromDevice];
    }
    self.isDfuModel = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self loadSectionDatas];
    
    // 三击手势 - Selftest 入口
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(handleTripleTap)];
    gesture.numberOfTapsRequired = 3;
    [self.view addGestureRecognizer:gesture];
    
    // 业务如果有 DFU 流程，监听通知
    if ([self.protocol respondsToSelector:@selector(deviceInfoPageShouldObserveDFUNotification)] &&
        [self.protocol deviceInfoPageShouldObserveDFUNotification]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(deviceStartDFUProcess)
                                                     name:@"mk_loraModule_deviceInfo_startDfuProcessNotification"
                                                   object:nil];
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    // section0 / section3 / section4 / section5 / section6 有 header
    if (section == 0 || section == 3 || section == 4 || section == 5 || section == 6) {
        return 10.f;
    }
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MKTableSectionLineHeader *headerView = [MKTableSectionLineHeader initHeaderViewWithTableView:tableView];
    if (section < self.headerList.count) {
        headerView.headerModel = self.headerList[section];
    }
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Firmware 行点击
    if (indexPath.section == 1 && indexPath.row == 0) {
        if ([self.protocol respondsToSelector:@selector(deviceInfoPageShouldHandleFirmwareTap)] &&
            [self.protocol deviceInfoPageShouldHandleFirmwareTap]) {
            return;
        }
        return;
    }
    
    // Battery Consumption Information
    if (indexPath.section == 5 && indexPath.row == 0) {
        if ([self.protocol respondsToSelector:@selector(deviceInfoPageDidSelectBatteryConsumption)]) {
            [self.protocol deviceInfoPageDidSelectBatteryConsumption];
        }
        return;
    }
    
    // Debugger Mode
    if (indexPath.section == 6 && indexPath.row == 0) {
        if ([self.protocol respondsToSelector:@selector(deviceInfoPageDidSelectDebuggerWithMacAddress:)]) {
            [self.protocol deviceInfoPageDidSelectDebuggerWithMacAddress:self.protocol.macAddress ?: @""];
        }
        return;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return self.section0List.count;
    if (section == 1) return self.section1List.count;
    if (section == 2) return self.section2List.count;
    if (section == 3) return self.section3List.count;
    if (section == 4) return self.section4List.count;
    if (section == 5) return self.section5List.count;
    if (section == 6) return self.section6List.count;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
    if (indexPath.section == 0) {
        cell.dataModel = self.section0List[indexPath.row];
    } else if (indexPath.section == 1) {
        cell.dataModel = self.section1List[indexPath.row];
    } else if (indexPath.section == 2) {
        cell.dataModel = self.section2List[indexPath.row];
    } else if (indexPath.section == 3) {
        cell.dataModel = self.section3List[indexPath.row];
    } else if (indexPath.section == 4) {
        cell.dataModel = self.section4List[indexPath.row];
    } else if (indexPath.section == 5) {
        cell.dataModel = self.section5List[indexPath.row];
    } else if (indexPath.section == 6) {
        cell.dataModel = self.section6List[indexPath.row];
    }
    return cell;
}

#pragma mark - interface

- (void)readDataFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.protocol readDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self updateCellDatas];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)updateCellDatas {
    if (ValidStr(self.protocol.software)) {
        MKNormalTextCellModel *softwareModel = self.section0List[0];
        softwareModel.rightMsg = self.protocol.software;
    }
    if (ValidStr(self.protocol.firmware)) {
        MKNormalTextCellModel *firmwareModel = self.section1List[0];
        firmwareModel.rightMsg = self.protocol.firmware;
    }
    if (ValidStr(self.protocol.hardware)) {
        MKNormalTextCellModel *hardware = self.section2List[0];
        hardware.rightMsg = self.protocol.hardware;
    }
    if (ValidStr(self.protocol.voltage)) {
        MKNormalTextCellModel *voltage = self.section3List[0];
        voltage.rightMsg = [self.protocol.voltage stringByAppendingString:@"mV"];
    }
    if (ValidStr(self.protocol.macAddress)) {
        MKNormalTextCellModel *mac = self.section4List[0];
        mac.rightMsg = self.protocol.macAddress;
    }
    if (ValidStr(self.protocol.productMode)) {
        MKNormalTextCellModel *produceModel = self.section4List[1];
        produceModel.rightMsg = self.protocol.productMode;
    }
    if (ValidStr(self.protocol.manu)) {
        MKNormalTextCellModel *manuModel = self.section4List[2];
        manuModel.rightMsg = self.protocol.manu;
    }
    
    // Cellular 专属字段（如果有）
    if ([self.protocol respondsToSelector:@selector(iccid)] && ValidStr([self.protocol iccid])) {
        MKNormalTextCellModel *iccidModel = [[MKNormalTextCellModel alloc] init];
        iccidModel.leftMsg = @"ICCID";
        iccidModel.rightMsg = [self.protocol iccid];
        [self.section4List addObject:iccidModel];
    }
    if ([self.protocol respondsToSelector:@selector(imei)] && ValidStr([self.protocol imei])) {
        MKNormalTextCellModel *imeiModel = [[MKNormalTextCellModel alloc] init];
        imeiModel.leftMsg = @"IMEI";
        imeiModel.rightMsg = [self.protocol imei];
        [self.section4List addObject:imeiModel];
    }
    
    [self.tableView reloadData];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_customUIModule_dismissPickView"
                                                        object:nil
                                                      userInfo:nil];
}

#pragma mark - loadSectionDatas

- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadSection1Datas];
    [self loadSection2Datas];
    [self loadSection3Datas];
    [self loadSection4Datas];
    [self loadSection5Datas];
    [self loadSection6Datas];
    
    // 7 个 section 对应 7 个 header（但部分 section header height = 0）
    for (NSInteger i = 0; i < 7; i++) {
        MKTableSectionLineHeaderModel *headerModel = [[MKTableSectionLineHeaderModel alloc] init];
        [self.headerList addObject:headerModel];
    }
    
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    MKNormalTextCellModel *cellModel = [[MKNormalTextCellModel alloc] init];
    cellModel.leftMsg = @"Software Version";
    [self.section0List addObject:cellModel];
}

- (void)loadSection1Datas {
    MKNormalTextCellModel *cellModel = [[MKNormalTextCellModel alloc] init];
    cellModel.leftMsg = @"Firmware Version";
    [self.section1List addObject:cellModel];
}

- (void)loadSection2Datas {
    MKNormalTextCellModel *cellModel = [[MKNormalTextCellModel alloc] init];
    cellModel.leftMsg = @"Hardware Version";
    [self.section2List addObject:cellModel];
}

- (void)loadSection3Datas {
    MKNormalTextCellModel *cellModel = [[MKNormalTextCellModel alloc] init];
    cellModel.leftMsg = @"Battery Voltage";
    [self.section3List addObject:cellModel];
}

- (void)loadSection4Datas {
    MKNormalTextCellModel *cellModel1 = [[MKNormalTextCellModel alloc] init];
    cellModel1.leftMsg = @"MAC Address";
    [self.section4List addObject:cellModel1];
    
    MKNormalTextCellModel *cellModel2 = [[MKNormalTextCellModel alloc] init];
    cellModel2.leftMsg = @"Product Model";
    [self.section4List addObject:cellModel2];
    
    MKNormalTextCellModel *cellModel3 = [[MKNormalTextCellModel alloc] init];
    cellModel3.leftMsg = @"Manufacture";
    [self.section4List addObject:cellModel3];
}

- (void)loadSection5Datas {
    MKNormalTextCellModel *cellModel = [[MKNormalTextCellModel alloc] init];
    cellModel.showRightIcon = YES;
    cellModel.leftMsg = @"Battery Consumption Information";
    [self.section5List addObject:cellModel];
}

- (void)loadSection6Datas {
    MKNormalTextCellModel *cellModel = [[MKNormalTextCellModel alloc] init];
    cellModel.showRightIcon = YES;
    cellModel.leftMsg = @"Debugger Mode";
    [self.section6List addObject:cellModel];
}

#pragma mark - event

- (void)handleTripleTap {
    if ([self.protocol respondsToSelector:@selector(deviceInfoPageDidTripleTap)]) {
        [self.protocol deviceInfoPageDidTripleTap];
    }
}

- (void)deviceStartDFUProcess {
    self.isDfuModel = YES;
}

#pragma mark - UI

- (void)loadSubViews {
    self.defaultTitle = @"Device Information";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.equalTo(self.view).offset(kTopBarHeight);
        make.bottom.equalTo(self.view).offset(-kSafeAreaHeight);
    }];
}

#pragma mark - getter

- (MKBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = RGBCOLOR(242, 242, 242);
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)section0List {
    if (!_section0List) { _section0List = [NSMutableArray array]; }
    return _section0List;
}

- (NSMutableArray *)section1List {
    if (!_section1List) { _section1List = [NSMutableArray array]; }
    return _section1List;
}

- (NSMutableArray *)section2List {
    if (!_section2List) { _section2List = [NSMutableArray array]; }
    return _section2List;
}

- (NSMutableArray *)section3List {
    if (!_section3List) { _section3List = [NSMutableArray array]; }
    return _section3List;
}

- (NSMutableArray *)section4List {
    if (!_section4List) { _section4List = [NSMutableArray array]; }
    return _section4List;
}

- (NSMutableArray *)section5List {
    if (!_section5List) { _section5List = [NSMutableArray array]; }
    return _section5List;
}

- (NSMutableArray *)section6List {
    if (!_section6List) { _section6List = [NSMutableArray array]; }
    return _section6List;
}

- (NSMutableArray *)headerList {
    if (!_headerList) { _headerList = [NSMutableArray array]; }
    return _headerList;
}

@end
