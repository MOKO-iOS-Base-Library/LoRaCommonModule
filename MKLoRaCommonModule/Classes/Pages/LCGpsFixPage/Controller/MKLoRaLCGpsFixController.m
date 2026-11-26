//
//  MKLoRaLCGpsFixController.m
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/18.
//

#import "MKLoRaLCGpsFixController.h"

#import "Masonry.h"
#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"
#import "MKTextFieldCell.h"
#import "MKTextSwitchCell.h"

@interface MKLoRaLCGpsFixController ()<UITableViewDelegate,
UITableViewDataSource,
MKTextFieldCellDelegate,
mk_textSwitchCellDelegate>

@property (nonatomic, strong) MKBaseTableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataList;

@property (nonatomic, strong) NSMutableArray *switchList;

@end

@implementation MKLoRaLCGpsFixController

- (void)dealloc {
    NSLog(@"MKLoRaLCGpsFixController销毁");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
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
    return 44.f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (self.supportsExtrmeMode ? 2 : 1);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.dataList.count;
    }
    return self.switchList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        MKTextSwitchCell *cell = [MKTextSwitchCell initCellWithTableView:tableView];
        cell.dataModel = self.switchList[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
    cell.dataModel = self.dataList[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - MKTextFieldCellDelegate
- (void)mk_deviceTextCellValueChanged:(NSInteger)index textValue:(NSString *)value {
    if (index == 0) {
        self.protocol.timeout = value;
        MKTextFieldCellModel *cellModel = self.dataList[0];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 1) {
        self.protocol.pdop = value;
        MKTextFieldCellModel *cellModel = self.dataList[1];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 2) {
        self.protocol.duration = value;
        MKTextFieldCellModel *cellModel = self.dataList[2];
        cellModel.textFieldValue = value;
        return;
    }
}

#pragma mark - mk_textSwitchCellDelegate
- (void)mk_textSwitchCellStatusChanged:(BOOL)isOn index:(NSInteger)index {
    if (index == 0) {
        self.protocol.extrmeMode = isOn;
        MKTextSwitchCellModel *cellModel = self.switchList[0];
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

#pragma mark - loadSections
- (void)loadSectionDatas {
    [self loadSection0Datas];
    if (self.supportsExtrmeMode) {
        [self loadSection1Datas];
    }
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    MKTextFieldCellModel *cellModel1 = [[MKTextFieldCellModel alloc] init];
    cellModel1.index = 0;
    cellModel1.msg = @"Positioning Timeout";
    cellModel1.textFieldValue = self.protocol.timeout;
    if ([self.protocol respondsToSelector:@selector(timeoutRangeText)]
        && ValidStr(self.protocol.timeoutRangeText)) {
        cellModel1.textPlaceholder = self.protocol.timeoutRangeText;
    }else {
        cellModel1.textPlaceholder = @"30 ~ 600";
    }
    cellModel1.textFieldType = mk_realNumberOnly;
    cellModel1.unit = @"s";
    cellModel1.maxLength = 3;
    [self.dataList addObject:cellModel1];
    
    MKTextFieldCellModel *cellModel2 = [[MKTextFieldCellModel alloc] init];
    cellModel2.index = 1;
    cellModel2.msg = @"PDOP";
    cellModel2.textFieldValue = self.protocol.pdop;
    if ([self.protocol respondsToSelector:@selector(pdopRangeText)]
        && ValidStr(self.protocol.pdopRangeText)) {
        cellModel2.textPlaceholder = self.protocol.pdopRangeText;
    }else {
        cellModel2.textPlaceholder = @"5 ~ 100";
    }
    cellModel2.textFieldType = mk_realNumberOnly;
    cellModel2.unit = @"x0.1";
    cellModel2.maxLength = 3;
    [self.dataList addObject:cellModel2];
    
    if (![self.protocol respondsToSelector:@selector(duration)]) {
        return;
    }
    MKTextFieldCellModel *cellModel3 = [[MKTextFieldCellModel alloc] init];
    cellModel3.index = 2;
    cellModel3.msg = @"Extra Positioning Duration";
    cellModel3.textFieldValue = self.protocol.duration;
    if ([self.protocol respondsToSelector:@selector(durationRangeText)]
        && ValidStr(self.protocol.durationRangeText)) {
        cellModel3.textPlaceholder = self.protocol.durationRangeText;
    }else {
        cellModel3.textPlaceholder = @"30 ~ 600";
    }
    cellModel3.textFieldType = mk_realNumberOnly;
    cellModel3.unit = @"s";
    cellModel3.maxLength = 3;
    [self.dataList addObject:cellModel3];
}

- (void)loadSection1Datas {
    NSString *title = @"Extrme Mode";
    if ([self.protocol respondsToSelector:@selector(extrmeModeTitle)]
        && ValidStr(self.protocol.extrmeModeTitle)) {
        title = self.protocol.extrmeModeTitle;
    }
    MKTextSwitchCellModel *cellModel = [[MKTextSwitchCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = title;
    cellModel.isOn = self.protocol.extrmeMode;
    [self.switchList addObject:cellModel];
}

#pragma mark - getter
- (BOOL)supportsExtrmeMode {
    return [self.protocol respondsToSelector:@selector(extrmeMode)];
}

#pragma mark - Subclass Override
/// 子类 override 提供右侧保存图标
- (UIImage *)rightButtonImage {
    return nil;
}

#pragma mark - UI
- (void)loadSubViews {
    UIImage *saveIcon = nil;
    if ([self.protocol respondsToSelector:@selector(lcGpsFixPageSaveIcon)]) {
        saveIcon = [self.protocol lcGpsFixPageSaveIcon];
    }
    if (!saveIcon) {
        saveIcon = [self rightButtonImage];
    }
    if (!saveIcon) {
        saveIcon = LOADICON(@"MKLoRaCommonModule", @"MKLoRaLCGpsFixController", @"mk_loraModule_loraDeviceMode_slotSaveIcon.png");
    }
    [self.rightButton setImage:saveIcon forState:UIControlStateNormal];
    self.defaultTitle = @"GPS Fix";
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

- (NSMutableArray *)switchList {
    if (!_switchList) {
        _switchList = [NSMutableArray array];
    }
    return _switchList;
}

@end
