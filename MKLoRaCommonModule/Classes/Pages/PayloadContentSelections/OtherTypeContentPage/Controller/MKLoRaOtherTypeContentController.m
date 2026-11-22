//
//  MKLoRaOtherTypeContentController.m
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/18.
//

#import "MKLoRaOtherTypeContentController.h"
#import "Pages/PayloadContentSelections/OtherTypeContentPage/Protocol/MKLoRaOtherTypeContentPageProtocol.h"
#import "Views/OtherAddOptionsCell/MKLoRaOtherAddOptionsCell.h"
#import "Views/OtherTypeContentCell/MKLoRaOtherTypeContentCell.h"

#import "Masonry.h"
#import "MLInputDodger.h"
#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"
#import "MKTableSectionLineHeader.h"
#import "MKHudManager.h"
#import "MKTextSwitchCell.h"

@interface MKLoRaOtherTypeContentController ()<UITableViewDelegate,
UITableViewDataSource,
mk_textSwitchCellDelegate,
MKLoRaOtherAddOptionsCellDelegate,
MKLoRaOtherTypeContentCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *section2List;

@property (nonatomic, strong)NSMutableArray *section3List;

@property (nonatomic, strong)NSMutableArray *headerList;

@end

@implementation MKLoRaOtherTypeContentController

- (void)dealloc {
    NSLog(@"MKLoRaOtherTypeContentController销毁");
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return (section == [self dataBlockSection]) ? 0.f : 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MKTableSectionLineHeader *headerView = [MKTableSectionLineHeader initHeaderViewWithTableView:tableView];
    headerView.headerModel = self.headerList[section];
    return headerView;
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
    if (self.showExtendedFields && section == 2) {
        return self.section2List.count;
    }
    if (self.showExtendedFields && section == 3) {
        return self.section3List.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.showExtendedFields && (indexPath.section == 0 || indexPath.section == 3)) {
        MKTextSwitchCell *cell = [MKTextSwitchCell initCellWithTableView:tableView];
        cell.dataModel = (indexPath.section == 0) ? self.section0List[indexPath.row] : self.section3List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    NSInteger optionsSection = self.showExtendedFields ? 1 : 0;
    if (indexPath.section == optionsSection) {
        MKLoRaOtherAddOptionsCell *cell = [MKLoRaOtherAddOptionsCell initCellWithTableView:tableView];
        cell.dataModel = self.showExtendedFields ? self.section1List[indexPath.row] : self.section0List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    MKLoRaOtherTypeContentCell *cell = [MKLoRaOtherTypeContentCell initCellWithTableView:tableView];
    cell.dataModel = [self dataBlockList][indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - mk_textSwitchCellDelegate
- (void)mk_textSwitchCellStatusChanged:(BOOL)isOn index:(NSInteger)index {
    if (!self.showExtendedFields) {
        return;
    }
    if (index == 0) {
        self.protocol.macAddress = isOn;
        MKTextSwitchCellModel *cellModel = self.section0List[0];
        cellModel.isOn = isOn;
        return;
    }
    if (index == 1) {
        self.protocol.rssi = isOn;
        MKTextSwitchCellModel *cellModel = self.section0List[1];
        cellModel.isOn = isOn;
        return;
    }
    if (index == 2) {
        self.protocol.timestamp = isOn;
        MKTextSwitchCellModel *cellModel = self.section0List[2];
        cellModel.isOn = isOn;
        return;
    }
    if (index == 3) {
        self.protocol.advertising = isOn;
        MKTextSwitchCellModel *cellModel = self.section3List[0];
        cellModel.isOn = isOn;
        return;
    }
    if (index == 4) {
        self.protocol.response = isOn;
        MKTextSwitchCellModel *cellModel = self.section3List[1];
        cellModel.isOn = isOn;
        return;
    }
}

#pragma mark - MKLoRaOtherAddOptionsCellDelegate
- (void)mk_loraModule_otherAddOptionsCellAddPressed:(NSInteger)index {
    NSMutableArray *dataList = [self dataBlockList];
    if (dataList.count >= 10) {
        [self.view showCentralToast:@"You can set up to 10 data blocks!"];
        return;
    }
    MKLoRaOtherTypeContentCellModel *cellModel = [[MKLoRaOtherTypeContentCellModel alloc] init];
    cellModel.blockNumber = 0;
    cellModel.blockIndex = dataList.count;
    cellModel.msg = [NSString stringWithFormat:@"Data block %ld",(long)(dataList.count + 1)];
    cellModel.unitMsg = @"Byte";
    [dataList addObject:cellModel];
    [self.tableView mk_reloadSection:[self dataBlockSection] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - MKLoRaOtherTypeContentCellDelegate
- (void)mk_loraModule_otherCellDeletedWithNumber:(NSInteger)blockNumber blockIndex:(NSInteger)blockIndex {
    if (blockNumber != 0) {
        return;
    }
    NSMutableArray *dataList = [self dataBlockList];
    if (dataList.count == 0 || blockIndex >= dataList.count) {
        return;
    }
    [dataList removeObjectAtIndex:blockIndex];
    for (NSInteger i = 0; i < dataList.count; i ++) {
        MKLoRaOtherTypeContentCellModel *cellModel = dataList[i];
        cellModel.blockIndex = i;
        cellModel.msg = [NSString stringWithFormat:@"Data block %ld",(long)(i + 1)];
    }
    [self.tableView mk_reloadSection:[self dataBlockSection] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)mk_loraModule_otherCellDataTypeChanged:(NSString *)dataType blockNumber:(NSInteger)blockNumber blockIndex:(NSInteger)blockIndex {
    if (blockNumber != 0) {
        return;
    }
    NSMutableArray *dataList = [self dataBlockList];
    if (dataList.count == 0 || blockIndex >= dataList.count) {
        return;
    }
    ((MKLoRaOtherTypeContentCellModel *)dataList[blockIndex]).dataType = dataType;
}

- (void)mk_loraModule_otherCellStartIndexChanged:(NSString *)startIndex blockNumber:(NSInteger)blockNumber blockIndex:(NSInteger)blockIndex {
    if (blockNumber != 0) {
        return;
    }
    NSMutableArray *dataList = [self dataBlockList];
    if (dataList.count == 0 || blockIndex >= dataList.count) {
        return;
    }
    ((MKLoRaOtherTypeContentCellModel *)dataList[blockIndex]).startIndex = startIndex;
}

- (void)mk_loraModule_otherCellEndIndexChanged:(NSString *)endIndex blockNumber:(NSInteger)blockNumber blockIndex:(NSInteger)blockIndex {
    if (blockNumber != 0) {
        return;
    }
    NSMutableArray *dataList = [self dataBlockList];
    if (dataList.count == 0 || blockIndex >= dataList.count) {
        return;
    }
    ((MKLoRaOtherTypeContentCellModel *)dataList[blockIndex]).endIndex = endIndex;
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
    NSMutableArray *optionList = [NSMutableArray array];
    NSArray *dataList = [self dataBlockList];
    for (NSInteger i = 0; i < dataList.count; i ++) {
        MKLoRaOtherTypeContentCellModel *cellModel = dataList[i];
        if (!ValidStr(cellModel.startIndex) || !ValidStr(cellModel.endIndex)) {
            [[MKHudManager share] hide];
            [self.view showCentralToast:[NSString stringWithFormat:@"Data block %@ Params Error",@(i + 1)]];
            return;
        }
        NSMutableDictionary *optionDict = [NSMutableDictionary dictionary];
        [optionDict setObject:SafeStr(cellModel.dataType) forKey:@"dataType"];
        [optionDict setObject:@([cellModel.startIndex integerValue]) forKey:@"minIndex"];
        [optionDict setObject:@([cellModel.endIndex integerValue]) forKey:@"maxIndex"];
        [optionList addObject:optionDict];
    }
    [self.protocol configBlockOptionList:optionList sucBlock:^{
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
    if (self.showExtendedFields) {
        [self loadSection2Datas];
        [self loadSection3Datas];
    }
    NSInteger sectionCount = self.showExtendedFields ? 4 : 2;
    for (NSInteger i = 0; i < sectionCount; i ++) {
        MKTableSectionLineHeaderModel *headerModel = [[MKTableSectionLineHeaderModel alloc] init];
        [self.headerList addObject:headerModel];
    }
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    if (!self.showExtendedFields) {
        [self loadOptionsDatas];
        return;
    }
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

- (void)loadSection1Datas {
    if (self.showExtendedFields) {
        [self loadOptionsDatas];
        return;
    }
    [self loadBlockDatas];
}

- (void)loadSection2Datas {
    [self loadBlockDatas];
}

- (void)loadSection3Datas {
    MKTextSwitchCellModel *cellModel1 = [[MKTextSwitchCellModel alloc] init];
    cellModel1.index = 3;
    cellModel1.msg = @"Raw data - Advertising";
    cellModel1.isOn = self.protocol.advertising;
    [self.section3List addObject:cellModel1];

    MKTextSwitchCellModel *cellModel2 = [[MKTextSwitchCellModel alloc] init];
    cellModel2.index = 4;
    cellModel2.msg = @"Raw data - Response";
    cellModel2.isOn = self.protocol.response;
    [self.section3List addObject:cellModel2];
}

- (void)loadOptionsDatas {
    MKLoRaOtherAddOptionsCellModel *cellModel = [[MKLoRaOtherAddOptionsCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = @"Data block Options";
    NSMutableArray *dataList = self.showExtendedFields ? self.section1List : self.section0List;
    [dataList addObject:cellModel];
}

- (void)loadBlockDatas {
    NSMutableArray *dataList = [self dataBlockList];
    for (NSInteger i = 0; i < self.protocol.blockList.count; i ++) {
        NSDictionary *model = self.protocol.blockList[i];
        MKLoRaOtherTypeContentCellModel *cellModel = [[MKLoRaOtherTypeContentCellModel alloc] init];
        cellModel.blockNumber = 0;
        cellModel.blockIndex = i;
        cellModel.msg = [NSString stringWithFormat:@"Data block %ld",(long)(i + 1)];
        cellModel.dataType = SafeStr(model[@"dataType"]);
        cellModel.startIndex = [NSString stringWithFormat:@"%ld",(long)[model[@"minIndex"] integerValue]];
        cellModel.endIndex = [NSString stringWithFormat:@"%ld",(long)[model[@"maxIndex"] integerValue]];
        cellModel.unitMsg = @"Byte";
        [dataList addObject:cellModel];
    }
}

#pragma mark - private method
- (BOOL)showExtendedFields {
    if ([self.protocol respondsToSelector:@selector(contentPageShowExtendedFields)]) {
        return [self.protocol contentPageShowExtendedFields];
    }
    return NO;
}

- (NSMutableArray *)dataBlockList {
    return self.showExtendedFields ? self.section2List : self.section1List;
}

- (NSInteger)dataBlockSection {
    return self.showExtendedFields ? 2 : 1;
}

#pragma mark - UI
- (void)loadSubViews {
    [self.rightButton setImage:LOADICON(@"MKLoRaCommonModule", @"MKLoRaOtherTypeContentController", @"mk_loraModule_loraDeviceMode_slotSaveIcon.png") forState:UIControlStateNormal];
    self.defaultTitle = @"Other Type Content";
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
