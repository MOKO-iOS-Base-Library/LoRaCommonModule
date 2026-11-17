//
//  MKLoRaBleSettingsController.m
//  MKLoRaCommonModule
//
//  Created by aa on 2025/xx/xx.
//

#import "MKLoRaBleSettingsController.h"

#import "Masonry.h"
#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"

#import "MKHudManager.h"
#import "MKTextFieldCell.h"
#import "MKTextSwitchCell.h"
#import "MKNormalTextCell.h"
#import "MKTableSectionLineHeader.h"

@interface MKLoRaBleSettingsController ()<UITableViewDelegate,
UITableViewDataSource,
MKTextFieldCellDelegate,
mk_textSwitchCellDelegate>

@property (nonatomic, strong) MKBaseTableView *tableView;

@property (nonatomic, strong) NSMutableArray *section0List;   // ADV Name + ADV Interval
@property (nonatomic, strong) NSMutableArray *section1List;   // Tx Power
@property (nonatomic, strong) NSMutableArray *section2List;   // Beacon Mode switch
@property (nonatomic, strong) NSMutableArray *section3List;   // Broadcast Timeout
@property (nonatomic, strong) NSMutableArray *section4List;   // Login Password switch
@property (nonatomic, strong) NSMutableArray *section5List;   // Change Password
@property (nonatomic, strong) NSMutableArray *headerList;

@end

@implementation MKLoRaBleSettingsController

- (void)dealloc {
    NSLog(@"MKLoRaBleSettingsController销毁");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
    // 本页面禁止右划退出手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 如果业务接管 Tx Power cell，让业务返回高度（通过 override heightForRow）
    if (indexPath.section == 1 &&
        [self.protocol respondsToSelector:@selector(bleSettingsPageShouldUseCustomTxPowerCell)] &&
        [self.protocol bleSettingsPageShouldUseCustomTxPowerCell]) {
        return 95.f;  // 默认和 AJ 一致，业务可 override
    }
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 4) {
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
    // Change Password
    if (indexPath.section == 5 && indexPath.row == 0) {
        BOOL canChangePassword = YES;
        if ([self.protocol respondsToSelector:@selector(hasLoginPassword)]) {
            canChangePassword = [self.protocol hasLoginPassword];
        }
        if (canChangePassword &&
            [self.protocol respondsToSelector:@selector(bleSettingsPageDidSelectChangePassword)]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MKTextFieldNeedHiddenKeyboard" object:nil];
            [self.protocol bleSettingsPageDidSelectChangePassword];
        }
        return;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.headerList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return self.section0List.count;
    if (section == 1) return self.section1List.count;
    if (section == 2) return self.section2List.count;
    if (section == 3) return (self.protocol.beaconMode ? 0 : self.section3List.count);
    if (section == 4) return self.section4List.count;
    if (section == 5) return (self.protocol.needPassword ? self.section5List.count : 0);
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 1) {
        // Tx Power - 基础版用 MKNormalTextCell 占位，显示当前值
        MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
        cell.dataModel = self.section1List[indexPath.row];
        return cell;
    }
    if (indexPath.section == 2) {
        MKTextSwitchCell *cell = [MKTextSwitchCell initCellWithTableView:tableView];
        cell.dataModel = self.section2List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 3) {
        MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
        cell.dataModel = self.section3List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 4) {
        MKTextSwitchCell *cell = [MKTextSwitchCell initCellWithTableView:tableView];
        cell.dataModel = self.section4List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    // section 5
    MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
    cell.dataModel = self.section5List[indexPath.row];
    return cell;
}

#pragma mark - MKTextFieldCellDelegate

- (void)mk_deviceTextCellValueChanged:(NSInteger)index textValue:(NSString *)value {
    if (index == 0) {
        self.protocol.advName = value;
        MKTextFieldCellModel *cellModel = self.section0List[0];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 1) {
        self.protocol.interval = value;
        MKTextFieldCellModel *cellModel = self.section0List[1];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 2) {
        self.protocol.timeout = value;
        MKTextFieldCellModel *cellModel = self.section3List[0];
        cellModel.textFieldValue = value;
        return;
    }
}

#pragma mark - mk_textSwitchCellDelegate

- (void)mk_textSwitchCellStatusChanged:(BOOL)isOn index:(NSInteger)index {
    if (index == 0) {
        // Beacon Mode
        self.protocol.beaconMode = isOn;
        MKTextSwitchCellModel *cellModel = self.section2List[0];
        cellModel.isOn = isOn;
        [self.tableView mk_reloadSection:3 withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
    if (index == 1) {
        // Login Password
        self.protocol.needPassword = isOn;
        MKTextSwitchCellModel *cellModel = self.section4List[0];
        cellModel.isOn = isOn;
        [self.tableView mk_reloadSection:5 withRowAnimation:UITableViewRowAnimationNone];
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
    [self loadSection0Datas];
    [self loadSection1Datas];
    [self loadSection2Datas];
    [self loadSection3Datas];
    [self loadSection4Datas];
    [self loadSection5Datas];
    
    for (NSInteger i = 0; i < 6; i++) {
        MKTableSectionLineHeaderModel *headerModel = [[MKTableSectionLineHeaderModel alloc] init];
        [self.headerList addObject:headerModel];
    }
    
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    MKTextFieldCellModel *cellModel1 = [[MKTextFieldCellModel alloc] init];
    cellModel1.index = 0;
    cellModel1.msg = @"ADV Name";
    cellModel1.maxLength = 16;
    cellModel1.textPlaceholder = @"0 ~ 16Characters";
    cellModel1.textFieldType = mk_normal;
    cellModel1.textFieldValue = self.protocol.advName;
    [self.section0List addObject:cellModel1];
    
    MKTextFieldCellModel *cellModel2 = [[MKTextFieldCellModel alloc] init];
    cellModel2.index = 1;
    cellModel2.msg = @"ADV Interval";
    cellModel2.maxLength = 3;
    cellModel2.unit = @"×100ms";
    cellModel2.textPlaceholder = @"1 ~ 100";
    cellModel2.textFieldType = mk_realNumberOnly;
    cellModel2.textFieldValue = self.protocol.interval;
    [self.section0List addObject:cellModel2];
}

- (void)loadSection1Datas {
    MKNormalTextCellModel *cellModel = [[MKNormalTextCellModel alloc] init];
    cellModel.leftMsg = @"Tx Power";
    // 如果业务提供了 dBm 显示文本就用业务的，否则显示数值索引
    if ([self.protocol respondsToSelector:@selector(bleSettingsPage_txPowerDisplayString)]) {
        cellModel.rightMsg = [self.protocol bleSettingsPage_txPowerDisplayString];
    } else {
        cellModel.rightMsg = [NSString stringWithFormat:@"%ld", (long)self.protocol.txPower];
    }
    [self.section1List addObject:cellModel];
}

- (void)loadSection2Datas {
    MKTextSwitchCellModel *cellModel = [[MKTextSwitchCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = @"Beacon  Mode";
    cellModel.isOn = self.protocol.beaconMode;
    [self.section2List addObject:cellModel];
}

- (void)loadSection3Datas {
    MKTextFieldCellModel *cellModel = [[MKTextFieldCellModel alloc] init];
    cellModel.index = 2;
    cellModel.msg = @"Broadcast Timeout";
    cellModel.maxLength = 2;
    cellModel.unit = @"Mins";
    cellModel.textPlaceholder = @"1 ~ 60";
    cellModel.textFieldType = mk_realNumberOnly;
    cellModel.textFieldValue = self.protocol.timeout;
    [self.section3List addObject:cellModel];
}

- (void)loadSection4Datas {
    MKTextSwitchCellModel *cellModel = [[MKTextSwitchCellModel alloc] init];
    cellModel.index = 1;
    cellModel.msg = @"Login Password";
    cellModel.isOn = self.protocol.needPassword;
    [self.section4List addObject:cellModel];
}

- (void)loadSection5Datas {
    MKNormalTextCellModel *cellModel = [[MKNormalTextCellModel alloc] init];
    cellModel.leftMsg = @"Change Password";
    cellModel.showRightIcon = YES;
    [self.section5List addObject:cellModel];
}

#pragma mark - UI

- (void)loadSubViews {
    [self.rightButton setImage:LOADICON(@"MKLoRaCommonModule", @"MKLoRaBleSettingsController", @"mk_loraModule_loraDeviceMode_slotSaveIcon.png") forState:UIControlStateNormal];
    self.defaultTitle = @"Bluetooth Settings";
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
- (NSMutableArray *)section4List { if (!_section4List) { _section4List = [NSMutableArray array]; } return _section4List; }
- (NSMutableArray *)section5List { if (!_section5List) { _section5List = [NSMutableArray array]; } return _section5List; }
- (NSMutableArray *)headerList { if (!_headerList) { _headerList = [NSMutableArray array]; } return _headerList; }

@end
