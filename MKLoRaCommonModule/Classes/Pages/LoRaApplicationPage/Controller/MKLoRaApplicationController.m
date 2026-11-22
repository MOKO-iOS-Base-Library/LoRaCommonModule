//
//  MKLoRaApplicationController.m
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/18.
//

#import "MKLoRaApplicationController.h"

#import "Masonry.h"
#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"
#import "MKTextFieldCell.h"
#import "MKSettingTextCell.h"
#import "MKTableSectionLineHeader.h"

@interface MKLoRaApplicationController ()<UITableViewDelegate,
UITableViewDataSource,
MKTextFieldCellDelegate>

@property (nonatomic, strong) MKBaseTableView *tableView;

@property (nonatomic, strong) NSMutableArray *multicaseList;

@property (nonatomic, strong) NSMutableArray *section0List;

@property (nonatomic, strong) NSMutableArray *section1List;

@property (nonatomic, strong) NSMutableArray *section2List;

@property (nonatomic, strong) NSMutableArray *headerList;

- (NSArray *)sectionListWithIndex:(NSInteger)index;
- (BOOL)hideMessageType;
- (NSString *)checkIntervalTitle;
- (NSString *)checkIntervalPlaceholder;
- (NSString *)checkIntervalUnit;

@end

@implementation MKLoRaApplicationController

- (void)dealloc {
    NSLog(@"MKLoRaApplicationController销毁");
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self sectionListWithIndex:section].count == 0) {
        return 0.f;
    }
    return 10.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MKTableSectionLineHeader *header = [MKTableSectionLineHeader initHeaderViewWithTableView:tableView];
    header.headerModel = self.headerList[section];
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self hasMulticaseSection] && indexPath.section == 0 && indexPath.row == 0) {
        if ([self.protocol respondsToSelector:@selector(pushToMulticaseGroupPageFromController:)]) {
            [self.protocol pushToMulticaseGroupPageFromController:self];
        }
        return;
    }
    NSInteger messageTypeSection = ([self hasMulticaseSection] ? 1 : 0);
    if (indexPath.section == messageTypeSection && indexPath.row == 0) {
        if ([self.protocol respondsToSelector:@selector(pushToMessageTypePageFromController:)]) {
            [self.protocol pushToMessageTypePageFromController:self];
            return;
        }
        [self pushToMessageTypePage];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.headerList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self sectionListWithIndex:section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id cellModel = [self sectionListWithIndex:indexPath.section][indexPath.row];
    if ([cellModel isKindOfClass:[MKSettingTextCellModel class]]) {
        MKSettingTextCell *cell = [MKSettingTextCell initCellWithTableView:tableView];
        cell.dataModel = cellModel;
        return cell;
    }
    MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
    cell.dataModel = cellModel;
    cell.delegate = self;
    return cell;
}

#pragma mark - MKTextFieldCellDelegate
- (void)mk_deviceTextCellValueChanged:(NSInteger)index textValue:(NSString *)value {
    if (index == 0) {
        MKTextFieldCellModel *cellModel = self.section1List[0];
        cellModel.textFieldValue = value;
        self.protocol.timeSyncInterval = value;
        return;
    }
    if (index == 1) {
        MKTextFieldCellModel *cellModel = self.section2List[0];
        cellModel.textFieldValue = value;
        self.protocol.checkInterval = value;
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
    [self loadMulticaseDatas];
    [self loadSection0Datas];
    [self loadSection1Datas];
    [self loadSection2Datas];

    NSInteger sectionCount = 3 + ([self hasMulticaseSection] ? 1 : 0);
    for (NSInteger i = 0; i < sectionCount; i ++) {
        MKTableSectionLineHeaderModel *headerModel = [[MKTableSectionLineHeaderModel alloc] init];
        [self.headerList addObject:headerModel];
    }
    [self.tableView reloadData];
}

- (void)loadMulticaseDatas {
    if (![self hasMulticaseSection]) {
        return;
    }
    MKSettingTextCellModel *cellModel = [[MKSettingTextCellModel alloc] init];
    cellModel.leftMsg = [self multicaseGroupTitle];
    [self.multicaseList addObject:cellModel];
}

- (void)loadSection0Datas {
    if ([self hideMessageType]) {
        return;
    }
    MKSettingTextCellModel *cellModel = [[MKSettingTextCellModel alloc] init];
    cellModel.leftMsg = @"Message Type Settings";
    [self.section0List addObject:cellModel];
}

- (void)loadSection1Datas {
    MKTextFieldCellModel *cellModel = [[MKTextFieldCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = @"Time Sync Interval";
    cellModel.textPlaceholder = @"0~255";
    cellModel.textFieldType = mk_realNumberOnly;
    cellModel.maxLength = 3;
    cellModel.unit = @"H";
    cellModel.textFieldValue = self.protocol.timeSyncInterval;
    [self.section1List addObject:cellModel];
}

- (void)loadSection2Datas {
    MKTextFieldCellModel *cellModel = [[MKTextFieldCellModel alloc] init];
    cellModel.index = 1;
    cellModel.msg = [self checkIntervalTitle];
    cellModel.textPlaceholder = [self checkIntervalPlaceholder];
    cellModel.textFieldType = mk_realNumberOnly;
    cellModel.maxLength = 3;
    cellModel.unit = [self checkIntervalUnit];
    cellModel.textFieldValue = self.protocol.checkInterval;
    [self.section2List addObject:cellModel];
}

#pragma mark - optional protocol
- (NSArray *)sectionListWithIndex:(NSInteger)index {
    if ([self hasMulticaseSection]) {
        if (index == 0) {
            return self.multicaseList;
        }
        index -= 1;
    }
    if (index == 0) {
        return self.section0List;
    }
    if (index == 1) {
        return self.section1List;
    }
    if (index == 2) {
        return self.section2List;
    }
    return @[];
}

- (BOOL)hasMulticaseSection {
    if ([self.protocol respondsToSelector:@selector(showMulticaseGroup)]) {
        return self.protocol.showMulticaseGroup;
    }
    return NO;
}

- (NSString *)multicaseGroupTitle {
    if ([self.protocol respondsToSelector:@selector(multicaseGroupTitle)]) {
        NSString *value = self.protocol.multicaseGroupTitle;
        if (ValidStr(value)) {
            return value;
        }
    }
    return @"Multicase Group";
}

- (BOOL)hideMessageType {
    if ([self.protocol respondsToSelector:@selector(hideMessageType)]) {
        return self.protocol.hideMessageType;
    }
    return NO;
}

- (NSString *)checkIntervalTitle {
    if ([self.protocol respondsToSelector:@selector(checkIntervalTitle)]) {
        NSString *value = self.protocol.checkIntervalTitle;
        if (ValidStr(value)) {
            return value;
        }
    }
    return @"Network Interval";
}

- (NSString *)checkIntervalPlaceholder {
    if ([self.protocol respondsToSelector:@selector(checkIntervalPlaceholder)]) {
        NSString *value = self.protocol.checkIntervalPlaceholder;
        if (ValidStr(value)) {
            return value;
        }
    }
    return @"0~255";
}

- (NSString *)checkIntervalUnit {
    if ([self.protocol respondsToSelector:@selector(checkIntervalUnit)]) {
        NSString *value = self.protocol.checkIntervalUnit;
        if (ValidStr(value)) {
            return value;
        }
    }
    return @"H";
}

#pragma mark - Subclass Override
- (void)pushToMessageTypePage {
    // 子类 override push 到 Message Type Settings 页面
}

#pragma mark - UI
- (void)loadSubViews {
    [self.rightButton setImage:LOADICON(@"MKLoRaCommonModule", @"MKLoRaApplicationController", @"mk_loraModule_loraDeviceMode_slotSaveIcon.png") forState:UIControlStateNormal];
    self.defaultTitle = @"Application Settings";
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

- (NSMutableArray *)multicaseList {
    if (!_multicaseList) {
        _multicaseList = [NSMutableArray array];
    }
    return _multicaseList;
}

- (NSMutableArray *)section0List {
    if (!_section0List) {
        _section0List = [NSMutableArray array];
    }
    return _section0List;
}

- (NSMutableArray *)section1List {
    if (!_section1List) {
        _section1List = [NSMutableArray array];
    }
    return _section1List;
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
