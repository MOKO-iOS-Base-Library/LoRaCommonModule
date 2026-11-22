//
//  MKLoRaBXPButtonContentController.m
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/18.
//

#import "MKLoRaBXPButtonContentController.h"
#import "Pages/PayloadContentSelections/BXPButtonContentPage/Protocol/MKLoRaBXPButtonContentPageProtocol.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"

#import "MKHudManager.h"
#import "MKTextSwitchCell.h"
#import "MKTableSectionLineHeader.h"

@interface MKLoRaBXPButtonContentController ()<UITableViewDelegate,
UITableViewDataSource,
mk_textSwitchCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section2List;

@property (nonatomic, strong)NSMutableArray *headerList;

@end

@implementation MKLoRaBXPButtonContentController

- (void)dealloc {
    NSLog(@"MKLoRaBXPButtonContentController销毁");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self readDatasFromDevice];
}

#pragma mark - super method
- (void)rightButtonMethod {
    [self saveDataToDevice];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self showExtendedFields] ? 10.f : 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (![self showExtendedFields]) {
        return nil;
    }
    MKTableSectionLineHeader *headerView = [MKTableSectionLineHeader initHeaderViewWithTableView:tableView];
    headerView.headerModel = self.headerList[section];
    return headerView;
}

#pragma mark - UITableViewDataSource
- (BOOL)showExtendedFields {
    if ([self.protocol respondsToSelector:@selector(contentPageShowExtendedFields)]) {
        return [self.protocol contentPageShowExtendedFields];
    }
    return NO;
}

- (NSMutableArray *)dataListForSection:(NSInteger)section {
    if (![self showExtendedFields]) {
        return (section == 0) ? self.dataList : [NSMutableArray array];
    }
    if (section == 0) {
        return self.section0List;
    }
    if (section == 1) {
        return self.dataList;
    }
    if (section == 2) {
        return self.section2List;
    }
    return [NSMutableArray array];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self showExtendedFields] ? self.headerList.count : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self dataListForSection:section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKTextSwitchCell *cell = [MKTextSwitchCell initCellWithTableView:tableView];
    NSArray *dataList = [self dataListForSection:indexPath.section];
    cell.dataModel = dataList[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - mk_textSwitchCellDelegate
- (void)mk_textSwitchCellStatusChanged:(BOOL)isOn index:(NSInteger)index {
    BOOL extended = [self showExtendedFields];
    if (extended && index == 0) {
        //MAC Address
        self.protocol.macAddress = isOn;
        MKTextSwitchCellModel *cellModel = self.section0List[0];
        cellModel.isOn = isOn;
        return;
    }
    if (extended && index == 1) {
        //RSSI
        self.protocol.rssi = isOn;
        MKTextSwitchCellModel *cellModel = self.section0List[1];
        cellModel.isOn = isOn;
        return;
    }
    if (extended && index == 2) {
        //Timestamp
        self.protocol.timestamp = isOn;
        MKTextSwitchCellModel *cellModel = self.section0List[2];
        cellModel.isOn = isOn;
        return;
    }
    if (extended && index == self.dataList.count + 3) {
        //Raw data - Advertising
        self.protocol.advertising = isOn;
        MKTextSwitchCellModel *cellModel = self.section2List[0];
        cellModel.isOn = isOn;
        return;
    }
    if (extended && index == self.dataList.count + 4) {
        //Raw data - Response
        self.protocol.response = isOn;
        MKTextSwitchCellModel *cellModel = self.section2List[1];
        cellModel.isOn = isOn;
        return;
    }
    NSInteger contentIndex = extended ? index - 3 : index;
    if (contentIndex < 0 || contentIndex >= (NSInteger)self.dataList.count) {
        return;
    }
    if (contentIndex == 0) {
        //Frame Type
        self.protocol.frameType = isOn;
        MKTextSwitchCellModel *cellModel = self.dataList[contentIndex];
        cellModel.isOn = isOn;
        return;
    }
    if (contentIndex == 1) {
        //Status Flag
        self.protocol.statusFlag = isOn;
        MKTextSwitchCellModel *cellModel = self.dataList[contentIndex];
        cellModel.isOn = isOn;
        return;
    }
    if (contentIndex == 2) {
        //Trigger Count
        self.protocol.triggerCount = isOn;
        MKTextSwitchCellModel *cellModel = self.dataList[contentIndex];
        cellModel.isOn = isOn;
        return;
    }
    if (contentIndex == 3) {
        //Device ID
        self.protocol.deviceID = isOn;
        MKTextSwitchCellModel *cellModel = self.dataList[contentIndex];
        cellModel.isOn = isOn;
        return;
    }
    if (contentIndex == 4) {
        //Firmware Type
        self.protocol.firmwareType = isOn;
        MKTextSwitchCellModel *cellModel = self.dataList[contentIndex];
        cellModel.isOn = isOn;
        return;
    }
    if (contentIndex == 5) {
        //Device Name
        self.protocol.deviceName = isOn;
        MKTextSwitchCellModel *cellModel = self.dataList[contentIndex];
        cellModel.isOn = isOn;
        return;
    }
    if (contentIndex == 6) {
        //Full Scale
        self.protocol.fullScale = isOn;
        MKTextSwitchCellModel *cellModel = self.dataList[contentIndex];
        cellModel.isOn = isOn;
        return;
    }
    if (contentIndex == 7) {
        //Motion Threshold
        self.protocol.motionThreshold = isOn;
        MKTextSwitchCellModel *cellModel = self.dataList[contentIndex];
        cellModel.isOn = isOn;
        return;
    }
    if (contentIndex == 8) {
        //3-axis Data
        self.protocol.axisData = isOn;
        MKTextSwitchCellModel *cellModel = self.dataList[contentIndex];
        cellModel.isOn = isOn;
        return;
    }
    if (contentIndex == 9) {
        //Temperature
        self.protocol.temperature = isOn;
        MKTextSwitchCellModel *cellModel = self.dataList[contentIndex];
        cellModel.isOn = isOn;
        return;
    }
    if (contentIndex == 10) {
        //Ranging Data
        self.protocol.rangingData = isOn;
        MKTextSwitchCellModel *cellModel = self.dataList[contentIndex];
        cellModel.isOn = isOn;
        return;
    }
    if (contentIndex == 11) {
        //Battery Voltage
        self.protocol.battery = isOn;
        MKTextSwitchCellModel *cellModel = self.dataList[contentIndex];
        cellModel.isOn = isOn;
        return;
    }
    if (contentIndex == 12) {
        //Tx Power
        self.protocol.txPower = isOn;
        MKTextSwitchCellModel *cellModel = self.dataList[contentIndex];
        cellModel.isOn = isOn;
        return;
    }
}

#pragma mark - interface
- (void)readDatasFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.protocol readDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self loadSectionDatas];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)saveDataToDevice {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.protocol configDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success"];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    MKTextSwitchCellModel *cellModel1 = [[MKTextSwitchCellModel alloc] init];
    cellModel1.index = 0;
    cellModel1.msg = @"Frame Type";
    cellModel1.isOn = self.protocol.frameType;
    [self.dataList addObject:cellModel1];
    
    MKTextSwitchCellModel *cellModel2 = [[MKTextSwitchCellModel alloc] init];
    cellModel2.index = 1;
    cellModel2.msg = @"Status Flag";
    cellModel2.isOn = self.protocol.statusFlag;
    [self.dataList addObject:cellModel2];
    
    MKTextSwitchCellModel *cellModel3 = [[MKTextSwitchCellModel alloc] init];
    cellModel3.index = 2;
    cellModel3.msg = @"Trigger Count";
    cellModel3.isOn = self.protocol.triggerCount;
    [self.dataList addObject:cellModel3];
    
    MKTextSwitchCellModel *cellModel4 = [[MKTextSwitchCellModel alloc] init];
    cellModel4.index = 3;
    cellModel4.msg = @"Device ID";
    cellModel4.isOn = self.protocol.deviceID;
    [self.dataList addObject:cellModel4];
    
    MKTextSwitchCellModel *cellModel5 = [[MKTextSwitchCellModel alloc] init];
    cellModel5.index = 4;
    cellModel5.msg = @"Firmware Type";
    cellModel5.isOn = self.protocol.firmwareType;
    [self.dataList addObject:cellModel5];
    
    MKTextSwitchCellModel *cellModel6 = [[MKTextSwitchCellModel alloc] init];
    cellModel6.index = 5;
    cellModel6.msg = @"Device Name";
    cellModel6.isOn = self.protocol.deviceName;
    [self.dataList addObject:cellModel6];
    
    MKTextSwitchCellModel *cellModel7 = [[MKTextSwitchCellModel alloc] init];
    cellModel7.index = 6;
    cellModel7.msg = @"Full Scale";
    cellModel7.isOn = self.protocol.fullScale;
    [self.dataList addObject:cellModel7];
    
    MKTextSwitchCellModel *cellModel8 = [[MKTextSwitchCellModel alloc] init];
    cellModel8.index = 7;
    cellModel8.msg = @"Motion Threshold";
    cellModel8.isOn = self.protocol.motionThreshold;
    [self.dataList addObject:cellModel8];
    
    MKTextSwitchCellModel *cellModel9 = [[MKTextSwitchCellModel alloc] init];
    cellModel9.index = 8;
    cellModel9.msg = @"3-axis Data";
    cellModel9.isOn = self.protocol.axisData;
    [self.dataList addObject:cellModel9];
    
    MKTextSwitchCellModel *cellModel10 = [[MKTextSwitchCellModel alloc] init];
    cellModel10.index = 9;
    cellModel10.msg = @"Temperature";
    cellModel10.isOn = self.protocol.temperature;
    [self.dataList addObject:cellModel10];
    
    MKTextSwitchCellModel *cellModel11 = [[MKTextSwitchCellModel alloc] init];
    cellModel11.index = 10;
    cellModel11.msg = @"Ranging Data";
    cellModel11.isOn = self.protocol.rangingData;
    [self.dataList addObject:cellModel11];
    
    MKTextSwitchCellModel *cellModel12 = [[MKTextSwitchCellModel alloc] init];
    cellModel12.index = 11;
    cellModel12.msg = @"Battery Voltage";
    cellModel12.isOn = self.protocol.battery;
    [self.dataList addObject:cellModel12];
    
    MKTextSwitchCellModel *cellModel13 = [[MKTextSwitchCellModel alloc] init];
    cellModel13.index = 12;
    cellModel13.msg = @"Tx Power";
    cellModel13.isOn = self.protocol.txPower;
    [self.dataList addObject:cellModel13];
    
    if ([self showExtendedFields]) {
        for (MKTextSwitchCellModel *cellModel in self.dataList) {
            cellModel.index += 3;
        }
        [self loadSection0Datas];
        [self loadSection2Datas];
        for (NSInteger i = 0; i < 3; i ++) {
            MKTableSectionLineHeaderModel *headerModel = [[MKTableSectionLineHeaderModel alloc] init];
            [self.headerList addObject:headerModel];
        }
    }
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    MKTextSwitchCellModel *cellModel1 = [[MKTextSwitchCellModel alloc] init];
    cellModel1.index = 0;
    cellModel1.msg = @"MAC Address";
    cellModel1.isOn = self.protocol.macAddress;
    [self.section0List addObject:cellModel1];

    MKTextSwitchCellModel *cellModel2 = [[MKTextSwitchCellModel alloc] init];
    cellModel2.index = 1;
    cellModel2.msg = @"RSSI";
    cellModel2.isOn = self.protocol.rssi;
    [self.section0List addObject:cellModel2];

    MKTextSwitchCellModel *cellModel3 = [[MKTextSwitchCellModel alloc] init];
    cellModel3.index = 2;
    cellModel3.msg = @"Timestamp";
    cellModel3.isOn = self.protocol.timestamp;
    [self.section0List addObject:cellModel3];
}

- (void)loadSection2Datas {
    MKTextSwitchCellModel *cellModel1 = [[MKTextSwitchCellModel alloc] init];
    cellModel1.index = self.dataList.count + 3;
    cellModel1.msg = @"Raw data - Advertising";
    cellModel1.isOn = self.protocol.advertising;
    [self.section2List addObject:cellModel1];

    MKTextSwitchCellModel *cellModel2 = [[MKTextSwitchCellModel alloc] init];
    cellModel2.index = self.dataList.count + 4;
    cellModel2.msg = @"Raw data - Response";
    cellModel2.isOn = self.protocol.response;
    [self.section2List addObject:cellModel2];
}

#pragma mark - UI
- (void)loadSubViews {
    [self.rightButton setImage:LOADICON(@"MKLoRaCommonModule", @"MKLoRaBXPButtonContentController", @"mk_loraModule_loraDeviceMode_slotSaveIcon.png") forState:UIControlStateNormal];
    self.defaultTitle = @"BXP-Button Content";
    [self setNavTitleFont:[UIFont systemFontOfSize:15.f]];
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
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (NSMutableArray *)section0List {
    if (!_section0List) {
        _section0List = [NSMutableArray array];
    }
    return _section0List;
}

- (NSMutableArray *)section2List {
    if (!_section2List) {
        _section2List = [NSMutableArray array];
    }
    return _section2List;
}

- (NSMutableArray *)headerList {
    if (!_headerList) {
        _headerList = [NSMutableArray array];
    }
    return _headerList;
}

@end
