//
//  MKLoRaAxisSettingController.m
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/18.
//

#import "MKLoRaAxisSettingController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"
#import "MKTextFieldCell.h"
#import "MKTextSwitchCell.h"

@interface MKLoRaAxisSettingController ()<UITableViewDelegate,
UITableViewDataSource,
mk_textSwitchCellDelegate,
MKTextFieldCellDelegate>

@property (nonatomic, strong) MKBaseTableView *tableView;

/// 如果业务实现了 isOn（AJ/AK/ST），则 section0 是开关，section1 是 4 个 TextField
/// 如果业务没实现 isOn（Cellular/WB/AF/AI/DL），则只有一个 section 包含 4 个 TextField
@property (nonatomic, strong) NSMutableArray *section0List;   // 可选：开关
@property (nonatomic, strong) NSMutableArray *section1List;   // 4 个 TextField

/// 业务是否有 isOn 开关
@property (nonatomic, assign) BOOL hasSwitch;

@end

@implementation MKLoRaAxisSettingController

- (void)dealloc {
    NSLog(@"MKLoRaAxisSettingController销毁");
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self checkHasSwitch];
    [self loadSubViews];
    [self readDataFromDevice];
}

#pragma mark - super method

- (void)rightButtonMethod {
    [self configDataToDevice];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.hasSwitch ? 2 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.hasSwitch) {
        if (section == 0) return self.section0List.count;
        return self.section1List.count;
    }
    return self.section1List.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.hasSwitch && indexPath.section == 0) {
        MKTextSwitchCell *cell = [MKTextSwitchCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
    NSArray *dataList = self.hasSwitch ? self.section1List : self.section1List;
    cell.dataModel = dataList[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - mk_textSwitchCellDelegate

- (void)mk_textSwitchCellStatusChanged:(BOOL)isOn index:(NSInteger)index {
    if (index == 0) {
        if ([self.protocol respondsToSelector:@selector(setIsOn:)]) {
            [self.protocol setIsOn:isOn];
        }
        MKTextSwitchCellModel *cellModel = self.section0List[0];
        cellModel.isOn = isOn;
        return;
    }
}

#pragma mark - MKTextFieldCellDelegate

- (void)mk_deviceTextCellValueChanged:(NSInteger)index textValue:(NSString *)value {
    MKTextFieldCellModel *cellModel = self.section1List[index];
    cellModel.textFieldValue = value;
    if (index == 0) {
        self.protocol.wakeupThreshold = value;
    } else if (index == 1) {
        self.protocol.wakeupDuration = value;
    } else if (index == 2) {
        self.protocol.motionThreshold = value;
    } else if (index == 3) {
        self.protocol.motionDuration = value;
    }
}

#pragma mark - interface

- (void)readDataFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.protocol readWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self loadSectionDatas];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)configDataToDevice {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.protocol configWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success"];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - private

- (void)checkHasSwitch {
    // 业务如果实现了 isOn 属性，就有一个 TextSwitch 行
    self.hasSwitch = [self.protocol respondsToSelector:@selector(isOn)];
}

#pragma mark - loadSectionDatas

- (void)loadSectionDatas {
    if (self.hasSwitch) {
        [self loadSection0Datas];
    }
    [self loadSection1Datas];
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    MKTextSwitchCellModel *cellModel = [[MKTextSwitchCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = @"3-Axis Sensor Switch";
    cellModel.isOn = [self.protocol respondsToSelector:@selector(isOn)] ? [self.protocol isOn] : NO;
    [self.section0List addObject:cellModel];
}

- (void)loadSection1Datas {
    MKTextFieldCellModel *cellModel1 = [[MKTextFieldCellModel alloc] init];
    cellModel1.index = 0;
    cellModel1.msg = @"Wakeup Threshold";
    cellModel1.textPlaceholder = @"1~20";
    cellModel1.textFieldType = mk_realNumberOnly;
    cellModel1.maxLength = 2;
    cellModel1.unit = @"x16mg";
    cellModel1.textFieldValue = self.protocol.wakeupThreshold;
    [self.section1List addObject:cellModel1];
    
    MKTextFieldCellModel *cellModel2 = [[MKTextFieldCellModel alloc] init];
    cellModel2.index = 1;
    cellModel2.msg = @"Wakeup Duration";
    cellModel2.textPlaceholder = @"1~10";
    cellModel2.textFieldType = mk_realNumberOnly;
    cellModel2.maxLength = 2;
    cellModel2.unit = @"x10ms";
    cellModel2.textFieldValue = self.protocol.wakeupDuration;
    [self.section1List addObject:cellModel2];
    
    MKTextFieldCellModel *cellModel3 = [[MKTextFieldCellModel alloc] init];
    cellModel3.index = 2;
    cellModel3.msg = @"Motion  Threshold";
    cellModel3.textPlaceholder = @"10~250";
    cellModel3.textFieldType = mk_realNumberOnly;
    cellModel3.maxLength = 3;
    cellModel3.unit = @"x2mg";
    cellModel3.textFieldValue = self.protocol.motionThreshold;
    [self.section1List addObject:cellModel3];
    
    MKTextFieldCellModel *cellModel4 = [[MKTextFieldCellModel alloc] init];
    cellModel4.index = 3;
    cellModel4.msg = @"Motion  Duration";
    cellModel4.textPlaceholder = @"1~50";
    cellModel4.textFieldType = mk_realNumberOnly;
    cellModel4.maxLength = 2;
    cellModel4.unit = @"x5ms";
    cellModel4.textFieldValue = self.protocol.motionDuration;
    [self.section1List addObject:cellModel4];
}

#pragma mark - UI

- (void)loadSubViews {
    [self.rightButton setImage:LOADICON(@"MKLoRaCommonModule", @"MKLoRaAxisSettingController", @"mk_loraModule_loraDeviceMode_slotSaveIcon.png") forState:UIControlStateNormal];
    self.defaultTitle = @"3-Axis Settings";
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

@end
