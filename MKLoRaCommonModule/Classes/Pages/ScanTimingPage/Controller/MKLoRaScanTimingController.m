//
//  MKLoRaScanTimingController.m
//  MKLoRaCommonModule_Example
//
//  Created by aa on 2026/11/18.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import "MKLoRaScanTimingController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"

#import "MKHudManager.h"
#import "MKTableSectionLineHeader.h"

#import "Models/ScanTimePoint/MKLoRaScanTimePointModel.h"

#import "Views/ReportTimePointCell/MKLoRaReportTimePointCell.h"
#import "Views/TimingModeAddCell/MKLoRaTimingModeAddCell.h"

@interface MKLoRaScanTimingController ()<UITableViewDelegate,
UITableViewDataSource,
MKLoRaTimingModeAddCellDelegate,
MKLoRaReportTimePointCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *headerList;

@property (nonatomic, strong) dispatch_source_t connectTimer;

@property (nonatomic, assign) NSInteger cmdCount;

@end

@implementation MKLoRaScanTimingController

- (void)dealloc {
    NSLog(@"MKLoRaScanTimingController销毁");
    if (self.connectTimer) {
        dispatch_cancel(self.connectTimer);
    }
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
    return 30.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10.f;
    }
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MKTableSectionLineHeader *header = [MKTableSectionLineHeader initHeaderViewWithTableView:tableView];
    header.headerModel = self.headerList[section];
    return header;
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
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKLoRaTimingModeAddCell *cell = [MKLoRaTimingModeAddCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    MKLoRaReportTimePointCell *cell = [MKLoRaReportTimePointCell initCellWithTableView:tableView];
    if ([self.protocol respondsToSelector:@selector(timePointMinuteGearList)]) {
        cell.minuteGearList = [self.protocol timePointMinuteGearList];
    }
    cell.dataModel = self.section1List[indexPath.row];
    cell.delegate = self;
    [cell resetFlagForFrame];
    return cell;
}

#pragma mark - MKLoRaTimingModeAddCellDelegate
- (void)mk_loraModule_addButtonPressed {
    if (self.section1List.count >= 24) {
        //最多10组
        [self.view showCentralToast:@"You can set up to 24 time points!"];
        return;
    }
    MKLoRaReportTimePointCellModel *cellModel = [[MKLoRaReportTimePointCellModel alloc] init];
    cellModel.index = self.section1List.count;
    cellModel.msg = [NSString stringWithFormat:@"Time Point %ld",(long)(self.section1List.count + 1)];
    cellModel.hour = 0;
    cellModel.timeSpace = 0;
    [self.section1List addObject:cellModel];
    
    [self.tableView mk_reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - MKLoRaReportTimePointCellDelegate
/**
 删除
 
 @param index 所在index
 */
- (void)mk_loraModule_cellDeleteButtonPressed:(NSInteger)index {
    if (index > self.section1List.count - 1) {
        return;
    }
    [self.section1List removeObjectAtIndex:index];
    
    for (NSInteger i = 0; i < self.section1List.count; i ++) {
        MKLoRaReportTimePointCellModel *cellModel = self.section1List[i];
        cellModel.index = i;
        cellModel.msg = [NSString stringWithFormat:@"Time Point %ld",(long)(i + 1)];
    }
    
    [self.tableView mk_reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
}

/// 用户选择了hour事件
- (void)mk_loraModule_hourButtonPressed:(NSInteger)index hour:(NSInteger)hour {
    if (![self cellCanSelected]) {
        return;
    }
    MKLoRaReportTimePointCellModel *cellModel = self.section1List[index];
    cellModel.hour = hour;
}

/// 用户选择了时间间隔事件
- (void)mk_loraModule_timeSpaceButtonPressed:(NSInteger)index timeSpace:(NSInteger)timeSpace {
    if (![self cellCanSelected]) {
        return;
    }
    MKLoRaReportTimePointCellModel *cellModel = self.section1List[index];
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
        [self connectTimerRun];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)saveDataToDevice {
    NSMutableArray *tempList = [NSMutableArray array];
    for (NSInteger i = 0; i < self.section1List.count; i ++) {
        MKLoRaReportTimePointCellModel *cellModel = self.section1List[i];
        MKLoRaScanTimePointModel *pointModel = [[MKLoRaScanTimePointModel alloc] init];
        pointModel.hour = cellModel.hour;
        pointModel.minuteGear = cellModel.timeSpace;
        [tempList addObject:pointModel];
    }
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.protocol configData:tempList sucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success"];
        [self connectTimerRun];
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

- (void)connectTimerRun{
    if (self.connectTimer) {
        dispatch_cancel(self.connectTimer);
    }
    self.cmdCount = 0;
    self.connectTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    //开始时间
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, 150 * NSEC_PER_SEC);
    //间隔时间
    uint64_t interval = 150 * NSEC_PER_SEC;
    dispatch_source_set_timer(self.connectTimer, start, interval, 0);
    @weakify(self);
    dispatch_source_set_event_handler(self.connectTimer, ^{
        @strongify(self);
        if (self.cmdCount == 3) {
            dispatch_cancel(self.connectTimer);
            return;
        }
        self.cmdCount ++;
        long long recordTime = [[NSDate date] timeIntervalSince1970];
        if ([self.protocol respondsToSelector:@selector(configDeviceTimeWithRecordTime:sucBlock:failedBlock:)]) {
            [self.protocol configDeviceTimeWithRecordTime:recordTime sucBlock:^{} failedBlock:^(NSError * _Nonnull error){}];
        }
    });
    dispatch_resume(self.connectTimer);
}

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadSection1Datas];
    
    for (NSInteger i = 0; i < 2; i ++) {
        MKTableSectionLineHeaderModel *headerModel = [[MKTableSectionLineHeaderModel alloc] init];
        [self.headerList addObject:headerModel];
    }
    
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    MKLoRaTimingModeAddCellModel * cellModel = [[MKLoRaTimingModeAddCellModel alloc] init];
    cellModel.msg = @"Report Time Point";
    [self.section0List addObject:cellModel];
}

- (void)loadSection1Datas {
    for (NSInteger i = 0; i < self.protocol.pointList.count; i ++) {
        MKLoRaScanTimePointModel *tempModel = self.protocol.pointList[i];
        MKLoRaReportTimePointCellModel *cellModel = [[MKLoRaReportTimePointCellModel alloc] init];
        cellModel.index = i;
        cellModel.msg = [NSString stringWithFormat:@"Time Point %ld",(long)(i + 1)];
        cellModel.hour = tempModel.hour;
        cellModel.timeSpace = tempModel.minuteGear;
        [self.section1List addObject:cellModel];
    }
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Scan Always On & Timing Report";
    [self setNavTitleFont:MKFont(12.f)];
    [self.rightButton setImage:LOADICON(@"MKLoRaCommonModule", @"MKLoRaScanTimingController", @"mk_loraModule_loraDeviceMode_slotSaveIcon.png") forState:UIControlStateNormal];
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

- (NSMutableArray *)headerList {
    if (!_headerList) {
        _headerList = [NSMutableArray array];
    }
    return _headerList;
}

@end
