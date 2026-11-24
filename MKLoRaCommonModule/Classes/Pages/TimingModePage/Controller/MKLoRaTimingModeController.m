//
//  MKLoRaTimingModeController.m
//  MKLoRaCommonModule_Example
//
//  Created by aa on 2026/11/18.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import "MKLoRaTimingModeController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"

#import "MKHudManager.h"
#import "MKTextButtonCell.h"

#import "Views/ReportTimePointCell/MKLoRaReportTimePointCell.h"
#import "Views/TimingModeAddCell/MKLoRaTimingModeAddCell.h"

@interface MKLoRaTimingModeController ()<UITableViewDelegate,
UITableViewDataSource,
MKTextButtonCellDelegate,
MKLoRaTimingModeAddCellDelegate,
MKLoRaReportTimePointCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *section2List;

- (BOOL)hideStrategy;
- (NSString *)pageTitle;

@end

@implementation MKLoRaTimingModeController

- (void)dealloc {
    NSLog(@"MKLoRaTimingModeController销毁");
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
    if (indexPath.section == 0) {
        return 44.f;
    }
    if (indexPath.section == 1) {
        return 30.f;
    }
    return 38.f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.section0List.count;
    }
    if (section == 1) {
        return self.section1List.count;
    }
    return self.section2List.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    
    if (indexPath.section == 1) {
        MKLoRaTimingModeAddCell *cell = [MKLoRaTimingModeAddCell initCellWithTableView:tableView];
        cell.dataModel = self.section1List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    MKLoRaReportTimePointCell *cell = [MKLoRaReportTimePointCell initCellWithTableView:tableView];
    if ([self.protocol respondsToSelector:@selector(timePointMinuteGearList)]) {
        cell.minuteGearList = [self.protocol timePointMinuteGearList];
    }
    cell.dataModel = self.section2List[indexPath.row];
    cell.delegate = self;
    [cell resetFlagForFrame];
    return cell;
}

#pragma mark - MKTextButtonCellDelegate
/// 右侧按钮点击触发的回调事件
/// @param index 当前cell所在的index
/// @param dataListIndex 点击按钮选中的dataList里面的index
/// @param value dataList[dataListIndex]
- (void)mk_loraTextButtonCellSelected:(NSInteger)index
                        dataListIndex:(NSInteger)dataListIndex
                                value:(NSString *)value {
    if (index == 0) {
        //Positioning Strategy
        MKTextButtonCellModel *cellModel = self.section0List[0];
        cellModel.dataListIndex = dataListIndex;
        self.protocol.strategy = dataListIndex;
        return;
    }
}

#pragma mark - MKLoRaTimingModeAddCellDelegate
- (void)mk_loraModule_addButtonPressed {
    NSInteger maxPointCount = (self.protocol.maxPointList > 0 ? self.protocol.maxPointList : 10);
    if (self.section2List.count >= maxPointCount) {
        //最多10组
        [self.view showCentralToast:[NSString stringWithFormat:@"You can set up to %@ time points!",@(maxPointCount)]];
        return;
    }
    MKLoRaReportTimePointCellModel *cellModel = [[MKLoRaReportTimePointCellModel alloc] init];
    cellModel.index = self.section2List.count;
    cellModel.msg = [NSString stringWithFormat:@"Time Point %ld",(long)(self.section2List.count + 1)];
    cellModel.hour = 0;
    cellModel.timeSpace = 0;
    [self.section2List addObject:cellModel];
    
    [self.tableView mk_reloadSection:2 withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - MKLoRaReportTimePointCellDelegate
/**
 删除
 
 @param index 所在index
 */
- (void)mk_loraModule_cellDeleteButtonPressed:(NSInteger)index {
    if (index > self.section2List.count - 1) {
        return;
    }
    [self.section2List removeObjectAtIndex:index];
    
    for (NSInteger i = 0; i < self.section2List.count; i ++) {
        MKLoRaReportTimePointCellModel *cellModel = self.section2List[i];
        cellModel.index = i;
        cellModel.msg = [NSString stringWithFormat:@"Time Point %ld",(long)(i + 1)];
    }
    
    [self.tableView mk_reloadSection:2 withRowAnimation:UITableViewRowAnimationNone];
}

/// 用户选择了hour事件
- (void)mk_loraModule_hourButtonPressed:(NSInteger)index hour:(NSInteger)hour {
    if (![self cellCanSelected]) {
        return;
    }
    MKLoRaReportTimePointCellModel *cellModel = self.section2List[index];
    cellModel.hour = hour;
}

/// 用户选择了时间间隔事件
- (void)mk_loraModule_timeSpaceButtonPressed:(NSInteger)index timeSpace:(NSInteger)timeSpace {
    if (![self cellCanSelected]) {
        return;
    }
    MKLoRaReportTimePointCellModel *cellModel = self.section2List[index];
    cellModel.timeSpace = timeSpace;
}

/**
 重新设置cell的子控件位置，主要是删除按钮方面的处理
 */
- (void)mk_loraModule_cellResetFrame {
    [self cellCanSelected];
}

- (void)mk_loraModule_cellTapAction {
    [self cellCanSelected];
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
    NSMutableArray *tempList = [NSMutableArray array];
    for (NSInteger i = 0; i < self.section2List.count; i ++) {
        MKLoRaReportTimePointCellModel *cellModel = self.section2List[i];
        MKLoRaTimingModeTimePointModel *pointModel = [[MKLoRaTimingModeTimePointModel alloc] init];
        pointModel.hour = cellModel.hour;
        if (cellModel.hour == 24) {
            pointModel.minuteGear = 0;
        }else {
            pointModel.minuteGear = cellModel.timeSpace;
        }
        [tempList addObject:pointModel];
    }
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.protocol configData:tempList sucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success"];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - private method
/**
 当有cell右侧的删除按钮出现时，不能触发点击事件
 
 @return YES可点击，NO不可点击
 */
- (BOOL)cellCanSelected{
    BOOL canSelected = YES;
    NSArray *arrCells = [self.tableView visibleCells];
    for (int i = 0; i < [arrCells count]; i++) {
        UITableViewCell *cell = arrCells[i];
        if ([cell isKindOfClass:MKLoRaReportTimePointCell.class]) {
            MKLoRaReportTimePointCell *tempCell = (MKLoRaReportTimePointCell *)cell;
            if ([tempCell canReset]) {
                [tempCell resetCellFrame];
                canSelected = NO;
            }
        }
    }
    return canSelected;
}

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadSection1Datas];
    [self loadSection2Datas];
    
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    if ([self hideStrategy]) {
        return;
    }
    MKTextButtonCellModel *cellModel = [[MKTextButtonCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = @"Positioning Strategy";
    cellModel.dataList = [self posStrategyDataList];
    cellModel.dataListIndex = self.protocol.strategy;
    [self.section0List addObject:cellModel];
}

- (void)loadSection1Datas {
    MKLoRaReportTimePointCellModel * cellModel = [[MKLoRaReportTimePointCellModel alloc] init];
    cellModel.msg = @"Reporting Time Point";
    [self.section1List addObject:cellModel];
}

- (void)loadSection2Datas {
    for (NSInteger i = 0; i < self.protocol.pointList.count; i ++) {
        MKLoRaTimingModeTimePointModel *tempModel = self.protocol.pointList[i];
        MKLoRaReportTimePointCellModel *cellModel = [[MKLoRaReportTimePointCellModel alloc] init];
        cellModel.index = i;
        cellModel.msg = [NSString stringWithFormat:@"Time Point %ld",(long)(i + 1)];
        cellModel.hour = tempModel.hour;
        cellModel.timeSpace = tempModel.minuteGear;
        [self.section2List addObject:cellModel];
    }
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = [self pageTitle];
    [self.rightButton setImage:LOADICON(@"MKLoRaCommonModule", @"MKLoRaTimingModeController", @"mk_loraModule_loraDeviceMode_slotSaveIcon.png") forState:UIControlStateNormal];
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

/// Positioning Strategy 下拉列表，可通过 protocol 的 strategyDataList 提供，也可由子类 override。
- (NSArray<NSString *> *)posStrategyDataList {
    if ([self.protocol respondsToSelector:@selector(strategyDataList)]) {
        NSArray<NSString *> *list = self.protocol.strategyDataList;
        if (list.count) {
            return list;
        }
    }
    return @[@"BLE",@"GPS",@"BLE+GPS",@"BLE*GPS"];
}

- (BOOL)hideStrategy {
    if ([self.protocol respondsToSelector:@selector(hideStrategy)]) {
        return self.protocol.hideStrategy;
    }
    return NO;
}

- (NSString *)pageTitle {
    if ([self.protocol respondsToSelector:@selector(pageTitle)]) {
        NSString *value = self.protocol.pageTitle;
        if (ValidStr(value)) {
            return value;
        }
    }
    return @"Timing Mode";
}

@end
