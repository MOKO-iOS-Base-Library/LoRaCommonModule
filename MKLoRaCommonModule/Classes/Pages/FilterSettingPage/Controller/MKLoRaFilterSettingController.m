//
//  MKLoRaFilterSettingController.m
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/23.
//

#import "MKLoRaFilterSettingController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"

#import "MKHudManager.h"
#import "MKNormalTextCell.h"
#import "MKNormalSliderCell.h"
#import "MKTableSectionLineHeader.h"
#import "MKCustomUIAdopter.h"

#import "MKLoRaFilterRelationshipCell.h"

@interface MKLoRaFilterSettingController ()<UITableViewDelegate,
UITableViewDataSource,
MKNormalSliderCellDelegate,
MKLoRaFilterRelationshipCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *section2List;

@property (nonatomic, strong)NSMutableArray *section3List;

@property (nonatomic, strong)NSMutableArray *headerList;

@end

@implementation MKLoRaFilterSettingController

- (void)dealloc {
    NSLog(@"MKLoRaFilterSettingController销毁");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
    //本页面禁止右划退出手势
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
    if (indexPath.section == 0) {
        return 90.f;
    }
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10.f;
    }
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MKTableSectionLineHeader *headerView = [MKTableSectionLineHeader initHeaderViewWithTableView:tableView];
    headerView.headerModel = self.headerList[section];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 2) {
        return;
    }
    if (indexPath.row == 0) {
        //Filter by MAC
        if ([self.protocol respondsToSelector:@selector(filterSettingPagePushFilterByMacFromController:)]) {
            [self.protocol filterSettingPagePushFilterByMacFromController:self];
        }
        return;
    }
    if (indexPath.row == 1) {
        //Filter by ADV Name
        if ([self.protocol respondsToSelector:@selector(filterSettingPagePushFilterByAdvNameFromController:)]) {
            [self.protocol filterSettingPagePushFilterByAdvNameFromController:self];
        }
        return;
    }
    if (indexPath.row == 2) {
        //Filter by Raw Data
        if ([self.protocol respondsToSelector:@selector(filterSettingPagePushFilterByRawDataFromController:)]) {
            [self.protocol filterSettingPagePushFilterByRawDataFromController:self];
        }
        return;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.headerList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.section0List.count;
    }
    if (section == 1) {
        return self.section1List.count;
    }
    if (section == 2) {
        return self.section2List.count;
    }
    if (section == 3) {
        return self.section3List.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKNormalSliderCell *cell = [MKNormalSliderCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 1) {
        MKLoRaFilterRelationshipCell *cell = [MKLoRaFilterRelationshipCell initCellWithTableView:tableView];
        cell.dataModel = self.section1List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 3) {
        MKLoRaFilterRelationshipCell *cell = [MKLoRaFilterRelationshipCell initCellWithTableView:tableView];
        cell.dataModel = self.section3List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
    cell.dataModel = self.section2List[indexPath.row];
    return cell;
}

#pragma mark - MKNormalSliderCellDelegate
/// slider值发生改变的回调事件
/// @param value 当前slider的值
/// @param index 当前cell所在的index
- (void)mk_normalSliderValueChanged:(NSInteger)value index:(NSInteger)index {
    if (index == 0) {
        //RSSI Filter
        self.protocol.rssi = value;
        MKNormalSliderCellModel *cellModel = self.section0List[0];
        cellModel.sliderValue = value;
        return;
    }
}

#pragma mark - MKLoRaFilterRelationshipCellDelegate
- (void)mk_loraFilterRelationshipChanged:(NSInteger)index dataListIndex:(NSInteger)dataListIndex {
    if (index == 0) {
        //Scanning Type/PHY
        self.protocol.phy = dataListIndex;
        MKLoRaFilterRelationshipCellModel *cellModel = self.section1List[0];
        cellModel.dataListIndex = dataListIndex;
        return;
    }
    if (index == 1) {
        //Filter Relationship
        self.protocol.relationship = dataListIndex;
        MKLoRaFilterRelationshipCellModel *cellModel = self.section1List[1];
        cellModel.dataListIndex = dataListIndex;
        return;
    }
    if (index == 2) {
        //Duplicate Data Filter
        if ([self.protocol respondsToSelector:@selector(setDataFilter:)]) {
            self.protocol.dataFilter = dataListIndex;
        }
        MKLoRaFilterRelationshipCellModel *cellModel = self.section3List[0];
        cellModel.dataListIndex = dataListIndex;
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
- (BOOL)showDuplicateDataFilter {
    return ([self.protocol respondsToSelector:@selector(filterSettingPageShowDuplicateDataFilter)]
            && [self.protocol filterSettingPageShowDuplicateDataFilter]);
}

- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadSection1Datas];
    [self loadSection2Datas];
    NSInteger sectionCount = 3;
    if ([self showDuplicateDataFilter]) {
        [self loadSection3Datas];
        sectionCount = 4;
    }
    
    for (NSInteger i = 0; i < sectionCount; i ++) {
        MKTableSectionLineHeaderModel *headerModel = [[MKTableSectionLineHeaderModel alloc] init];
        [self.headerList addObject:headerModel];
    }
    
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    MKNormalSliderCellModel *cellModel = [[MKNormalSliderCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = [MKCustomUIAdopter attributedString:@[@"RSSI Filter",@"   (-127dBm ~ 0dBm)"] fonts:@[MKFont(15.f),MKFont(13.f)] colors:@[DEFAULT_TEXT_COLOR,RGBCOLOR(223, 223, 223)]];
    cellModel.changed = YES;
    cellModel.noteMsgColor = RGBCOLOR(223, 223, 223);
    cellModel.leftNoteMsg = @"*The device will uplink valid ADV data with RSSI no less than";
    cellModel.rightNoteMsg = @".";
    cellModel.sliderValue = self.protocol.rssi;
    [self.section0List addObject:cellModel];
}

- (void)loadSection1Datas {
    MKLoRaFilterRelationshipCellModel *cellModel1 = [[MKLoRaFilterRelationshipCellModel alloc] init];
    cellModel1.index = 0;
    cellModel1.msg = @"Scanning Type/PHY";
    cellModel1.dataList = @[@"1M PHY (BLE 4.x)",@"1M PHY (BLE 5)",@"1M PHY(BLE4.x+BLE5)",
                            @"Coded PHY(BLE 5)"];
    cellModel1.dataListIndex = self.protocol.phy;
    [self.section1List addObject:cellModel1];
    
    MKLoRaFilterRelationshipCellModel *cellModel2 = [[MKLoRaFilterRelationshipCellModel alloc] init];
    cellModel2.index = 1;
    cellModel2.msg = @"Filter Relationship";
    cellModel2.dataList = @[@"Null",@"Only MAC",@"Only ADV Name",@"Only Raw Data",@"ADV Name & Raw Data",@"MAC & ADV Name & Raw Data",@"ADV Name | Raw Data"];
    cellModel2.dataListIndex = self.protocol.relationship;
    [self.section1List addObject:cellModel2];
}

- (void)loadSection2Datas {
    MKNormalTextCellModel *cellModel1 = [[MKNormalTextCellModel alloc] init];
    cellModel1.leftMsg = @"Filter by MAC";
    cellModel1.showRightIcon = YES;
    [self.section2List addObject:cellModel1];
    
    MKNormalTextCellModel *cellModel2 = [[MKNormalTextCellModel alloc] init];
    cellModel2.leftMsg = @"Filter by ADV Name";
    cellModel2.showRightIcon = YES;
    [self.section2List addObject:cellModel2];
    
    MKNormalTextCellModel *cellModel3 = [[MKNormalTextCellModel alloc] init];
    cellModel3.leftMsg = @"Filter by Raw Data";
    cellModel3.showRightIcon = YES;
    [self.section2List addObject:cellModel3];
}

- (void)loadSection3Datas {
    MKLoRaFilterRelationshipCellModel *cellModel1 = [[MKLoRaFilterRelationshipCellModel alloc] init];
    cellModel1.index = 2;
    cellModel1.msg = @"Duplicate Data Filter";
    NSArray *dataFilterList = nil;
    if ([self.protocol respondsToSelector:@selector(dataFilterList)]) {
        dataFilterList = [self.protocol dataFilterList];
    }
    if (!ValidArray(dataFilterList)) {
        dataFilterList = @[@"No",@"MAC",@"MAC+Data Type",@"MAC+Raw Data"];
    }
    cellModel1.dataList = dataFilterList;
    cellModel1.dataListIndex = ([self.protocol respondsToSelector:@selector(dataFilter)] ? self.protocol.dataFilter : 0);
    [self.section3List addObject:cellModel1];
}

#pragma mark - UI
- (void)loadSubViews {
    NSString *title = @"Bluetooth Filter Settings";
    if ([self.protocol respondsToSelector:@selector(filterSettingPageTitle)]) {
        NSString *tmpTitle = [self.protocol filterSettingPageTitle];
        if (ValidStr(tmpTitle)) {
            title = tmpTitle;
        }
    }
    self.defaultTitle = title;
    [self.rightButton setImage:LOADICON(@"MKLoRaCommonModule", @"MKLoRaFilterSettingController", @"mk_loraModule_loraDeviceMode_slotSaveIcon@2x.png") forState:UIControlStateNormal];
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

- (NSMutableArray *)section3List {
    if (!_section3List) {
        _section3List = [NSMutableArray array];
    }
    return _section3List;
}

- (NSMutableArray *)headerList {
    if (!_headerList) {
        _headerList = [NSMutableArray array];
    }
    return _headerList;
}

@end
