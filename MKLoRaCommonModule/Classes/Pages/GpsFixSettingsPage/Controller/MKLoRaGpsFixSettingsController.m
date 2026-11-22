//
//  MKLoRaGpsFixSettingsController.m
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/22.
//

#import "MKLoRaGpsFixSettingsController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"
#import "MKSettingTextCell.h"
#import "MKTextSwitchCell.h"
#import "MKTextFieldCell.h"
#import "MKTextButtonCell.h"
#import "MKTableSectionLineHeader.h"

@interface MKLoRaGpsFixSettingsController ()<UITableViewDelegate,
UITableViewDataSource,
MKTextButtonCellDelegate,
MKTextFieldCellDelegate,
mk_textSwitchCellDelegate>

@property (nonatomic, strong) MKBaseTableView *tableView;

@property (nonatomic, strong) NSMutableArray *section0List;   // GPS Fix Strategy

@property (nonatomic, strong) NSMutableArray *section1List;   // Positioning Timeout + PDOP

@property (nonatomic, strong) NSMutableArray *section2List;   // Report Settings 入口

@property (nonatomic, strong) NSMutableArray *section3List;   // GPS Extreme Mode

@property (nonatomic, strong) NSMutableArray *headerList;

@end

@implementation MKLoRaGpsFixSettingsController

- (void)dealloc {
    NSLog(@"MKLoRaGpsFixSettingsController销毁");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self readDataFromDevice];
}

#pragma mark - super method

- (void)rightButtonMethod {
    [self saveDataToDevice];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        return 0.f;
    }
    return 10.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MKTableSectionLineHeader *header = [MKTableSectionLineHeader initHeaderViewWithTableView:tableView];
    if (section < self.headerList.count) {
        header.headerModel = self.headerList[section];
    }
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // section2 的 Periodic/Timing/Motion Report Settings 入口由子类处理
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.headerList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return self.section0List.count;
    if (section == 1) return self.section1List.count;
    if (section == 2) return self.section2List.count;
    if (section == 3) return self.section3List.count;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 1) {
        MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
        cell.dataModel = self.section1List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 2) {
        MKSettingTextCell *cell = [MKSettingTextCell initCellWithTableView:tableView];
        cell.dataModel = self.section2List[indexPath.row];
        return cell;
    }
    MKTextSwitchCell *cell = [MKTextSwitchCell initCellWithTableView:tableView];
    cell.dataModel = self.section3List[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - MKTextButtonCellDelegate

- (void)mk_loraTextButtonCellSelected:(NSInteger)index
                        dataListIndex:(NSInteger)dataListIndex
                                value:(NSString *)value {
    if (index == 0) {
        // GPS Fix Strategy
        self.protocol.strategy = dataListIndex;
        MKTextButtonCellModel *cellModel = self.section0List[0];
        cellModel.dataListIndex = dataListIndex;
        return;
    }
}

#pragma mark - MKTextFieldCellDelegate

- (void)mk_deviceTextCellValueChanged:(NSInteger)index textValue:(NSString *)value {
    if (index == 0) {
        // Positioning Timeout
        self.protocol.timeout = value;
        MKTextFieldCellModel *cellModel = self.section1List[0];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 1) {
        // PDOP
        self.protocol.pdop = value;
        MKTextFieldCellModel *cellModel = self.section1List[1];
        cellModel.textFieldValue = value;
        return;
    }
}

#pragma mark - mk_textSwitchCellDelegate

- (void)mk_textSwitchCellStatusChanged:(BOOL)isOn index:(NSInteger)index {
    if (index == 0) {
        // GPS Extreme Mode
        self.protocol.gpsExtremeMode = isOn;
        MKTextSwitchCellModel *cellModel = self.section3List[0];
        cellModel.isOn = isOn;
        return;
    }
}

#pragma mark - interface

- (void)readDataFromDevice {
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

#pragma mark - loadSections

- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadSection1Datas];
    [self loadSection2Datas];
    [self loadSection3Datas];

    for (NSInteger i = 0; i < 4; i++) {
        MKTableSectionLineHeaderModel *headerModel = [[MKTableSectionLineHeaderModel alloc] init];
        [self.headerList addObject:headerModel];
    }

    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    NSArray *strategyList = nil;
    if ([self.protocol respondsToSelector:@selector(gpsFixSettingsPageStrategyList)]) {
        strategyList = [self.protocol gpsFixSettingsPageStrategyList];
    }
    if (!strategyList.count) {
        strategyList = @[@"No Report", @"Periodic Report", @"Timing Report", @"Motion Report", @"Report with BLE Payload"];
    }
    MKTextButtonCellModel *cellModel = [[MKTextButtonCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = @"GPS Fix Strategy";
    cellModel.dataListIndex = self.protocol.strategy;
    cellModel.dataList = strategyList;
    cellModel.buttonLabelFont = MKFont(13.f);
    [self.section0List addObject:cellModel];
}

- (void)loadSection1Datas {
    MKTextFieldCellModel *cellModel1 = [[MKTextFieldCellModel alloc] init];
    cellModel1.index = 0;
    cellModel1.msg = @"Positioning Timeout";
    cellModel1.textPlaceholder = @"30 ~ 600";
    cellModel1.textFieldType = mk_realNumberOnly;
    cellModel1.maxLength = 3;
    cellModel1.unit = @"s";
    cellModel1.textFieldValue = self.protocol.timeout;
    [self.section1List addObject:cellModel1];

    MKTextFieldCellModel *cellModel2 = [[MKTextFieldCellModel alloc] init];
    cellModel2.index = 1;
    cellModel2.msg = @"PDOP";
    cellModel2.textPlaceholder = @"5 ~ 100";
    cellModel2.textFieldType = mk_realNumberOnly;
    cellModel2.maxLength = 3;
    cellModel2.unit = @"x0.1";
    cellModel2.textFieldValue = self.protocol.pdop;
    [self.section1List addObject:cellModel2];
}

- (void)loadSection2Datas {
    MKSettingTextCellModel *cellModel1 = [[MKSettingTextCellModel alloc] init];
    cellModel1.leftMsg = @"Periodic Report Settings";
    [self.section2List addObject:cellModel1];

    MKSettingTextCellModel *cellModel2 = [[MKSettingTextCellModel alloc] init];
    cellModel2.leftMsg = @"Timing Report Settings";
    [self.section2List addObject:cellModel2];

    MKSettingTextCellModel *cellModel3 = [[MKSettingTextCellModel alloc] init];
    cellModel3.leftMsg = @"Motion Report Settings";
    [self.section2List addObject:cellModel3];
}

- (void)loadSection3Datas {
    MKTextSwitchCellModel *cellModel = [[MKTextSwitchCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = @"GPS Extreme Mode";
    cellModel.isOn = self.protocol.gpsExtremeMode;
    [self.section3List addObject:cellModel];
}

#pragma mark - UI

- (void)loadSubViews {
    self.defaultTitle = @"GPS Fix Function Settings";
    [self.rightButton setImage:LOADICON(@"MKLoRaCommonModule", @"MKLoRaGpsFixSettingsController", @"mk_loraModule_loraDeviceMode_slotSaveIcon.png") forState:UIControlStateNormal];
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

- (NSMutableArray *)section0List { if (!_section0List) { _section0List = [NSMutableArray array]; } return _section0List; }
- (NSMutableArray *)section1List { if (!_section1List) { _section1List = [NSMutableArray array]; } return _section1List; }
- (NSMutableArray *)section2List { if (!_section2List) { _section2List = [NSMutableArray array]; } return _section2List; }
- (NSMutableArray *)section3List { if (!_section3List) { _section3List = [NSMutableArray array]; } return _section3List; }
- (NSMutableArray *)headerList { if (!_headerList) { _headerList = [NSMutableArray array]; } return _headerList; }

@end
