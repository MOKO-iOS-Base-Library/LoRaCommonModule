//
//  MKTimingReportController.m
//  MKLoRaCommonModule_Example
//
//  Created by aa on 2025/5/11.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import "MKTimingReportController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"

#import "MKHudManager.h"
#import "MKTextFieldCell.h"
#import "MKTableSectionLineHeader.h"

#import "MKScanTimePointModel.h"

#import "MKReportTimePointCell.h"
#import "MKTimingModeAddCell.h"

/// 上报时间点cell的index在扫描时间点的基础上偏移，用于区分两个section的回调
static NSInteger const MKTimingReportPointOffset = 1000;

@class MKTimingReportController;

@interface MKTimingReportController (MKAddButton)
- (void)addTimePointWithType:(NSInteger)type;
@end

@interface MKTimingReportAddCellProxy : NSObject <MKTimingModeAddCellDelegate>

@property (nonatomic, weak) MKTimingReportController *owner;

@property (nonatomic, assign) NSInteger type;

@end

@implementation MKTimingReportAddCellProxy

- (void)mk_addButtonPressed {
    [self.owner addTimePointWithType:self.type];
}

@end

@interface MKTimingReportController ()<UITableViewDelegate,
UITableViewDataSource,
MKTextFieldCellDelegate,
MKReportTimePointCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *section2List;

@property (nonatomic, strong)NSMutableArray *section3List;

@property (nonatomic, strong)NSMutableArray *section4List;

@property (nonatomic, strong)NSMutableArray *headerList;

@property (nonatomic, strong)MKTimingReportAddCellProxy *scanAddProxy;

@property (nonatomic, strong)MKTimingReportAddCellProxy *reportAddProxy;

@property (nonatomic, strong) dispatch_source_t connectTimer;

@property (nonatomic, assign) NSInteger cmdCount;

@end

@implementation MKTimingReportController

- (void)dealloc {
    NSLog(@"MKTimingReportController销毁");
    if (self.connectTimer) {
        dispatch_cancel(self.connectTimer);
    }
}

- (void)viewDidAppear:(BOOL)animated{
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
    if (indexPath.section == 0) {
        return 44.f;
    }
    return 30.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 1 || section == 3) {
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
    if (section == 2) {
        return self.section2List.count;
    }
    if (section == 3) {
        return self.section3List.count;
    }
    if (section == 4) {
        return self.section4List.count;
    }
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
        MKTimingModeAddCell *cell = [MKTimingModeAddCell initCellWithTableView:tableView];
        cell.dataModel = self.section1List[indexPath.row];
        cell.delegate = self.scanAddProxy;
        return cell;
    }
    if (indexPath.section == 2) {
        MKReportTimePointCell *cell = [MKReportTimePointCell initCellWithTableView:tableView];
        cell.dataModel = self.section2List[indexPath.row];
        cell.delegate = self;
        [cell resetFlagForFrame];
        return cell;
    }
    if (indexPath.section == 3) {
        MKTimingModeAddCell *cell = [MKTimingModeAddCell initCellWithTableView:tableView];
        cell.dataModel = self.section3List[indexPath.row];
        cell.delegate = self.reportAddProxy;
        return cell;
    }
    MKReportTimePointCell *cell = [MKReportTimePointCell initCellWithTableView:tableView];
    cell.dataModel = self.section4List[indexPath.row];
    cell.delegate = self;
    [cell resetFlagForFrame];
    return cell;
}

#pragma mark - MKTextFieldCellDelegate
/// textField内容发送改变时的回调事件
/// @param index 当前cell所在的index
/// @param value 当前textField的值
- (void)mk_deviceTextCellValueChanged:(NSInteger)index textValue:(NSString *)value {
    if (index == 0) {
        //Bluetooth Scan Duration
        self.protocol.duration = value;
        MKTextFieldCellModel *cellModel = self.section0List[0];
        cellModel.textFieldValue = value;
        return;
    }
}

#pragma mark - add button
- (void)addTimePointWithType:(NSInteger)type {
    if (type == 0) {
        //Bluetooth Scan Time Point
        if (self.section2List.count >= 48) {
            //最多10组
            [self.view showCentralToast:@"You can set up to 48 time points!"];
            return;
        }
        MKReportTimePointCellModel *cellModel = [[MKReportTimePointCellModel alloc] init];
        cellModel.index = self.section2List.count;
        cellModel.msg = [NSString stringWithFormat:@"Time Point %ld",(long)(self.section2List.count + 1)];
        cellModel.hour = 0;
        cellModel.timeSpace = 0;
        [self.section2List addObject:cellModel];
        
        [self.tableView mk_reloadSection:2 withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
    if (type == 1) {
        //Report Time Point
        if (self.section4List.count >= 24) {
            //最多10组
            [self.view showCentralToast:@"You can set up to 24 time points!"];
            return;
        }
        MKReportTimePointCellModel *cellModel = [[MKReportTimePointCellModel alloc] init];
        cellModel.index = MKTimingReportPointOffset + self.section4List.count;
        cellModel.msg = [NSString stringWithFormat:@"Time Point %ld",(long)(self.section4List.count + 1)];
        cellModel.hour = 0;
        cellModel.timeSpace = 0;
        [self.section4List addObject:cellModel];
        
        [self.tableView mk_reloadSection:4 withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
}

#pragma mark - MKReportTimePointCellDelegate

- (void)mk_cellDeleteButtonPressed:(NSInteger)index {
    if (index >= MKTimingReportPointOffset) {
        //Report Time Point
        NSInteger row = index - MKTimingReportPointOffset;
        if (row > self.section4List.count - 1) {
            return;
        }
        [self.section4List removeObjectAtIndex:row];
        
        for (NSInteger i = 0; i < self.section4List.count; i ++) {
            MKReportTimePointCellModel *cellModel = self.section4List[i];
            cellModel.index = MKTimingReportPointOffset + i;
            cellModel.msg = [NSString stringWithFormat:@"Time Point %ld",(long)(i + 1)];
        }
        
        [self.tableView mk_reloadSection:4 withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
    //Bluetooth Scan Time Point
    if (index > self.section2List.count - 1) {
        return;
    }
    [self.section2List removeObjectAtIndex:index];
    
    for (NSInteger i = 0; i < self.section2List.count; i ++) {
        MKReportTimePointCellModel *cellModel = self.section2List[i];
        cellModel.index = i;
        cellModel.msg = [NSString stringWithFormat:@"Time Point %ld",(long)(i + 1)];
    }
    
    [self.tableView mk_reloadSection:2 withRowAnimation:UITableViewRowAnimationNone];
}

/// 用户选择了hour事件
- (void)mk_hourButtonPressed:(NSInteger)index hour:(NSInteger)hour {
    if (![self cellCanSelected]) {
        return;
    }
    MKReportTimePointCellModel *cellModel = [self pointCellModelWithIndex:index];
    if (!cellModel) {
        return;
    }
    cellModel.hour = hour;
}

/// 用户选择了时间间隔事件
- (void)mk_timeSpaceButtonPressed:(NSInteger)index timeSpace:(NSInteger)timeSpace {
    if (![self cellCanSelected]) {
        return;
    }
    MKReportTimePointCellModel *cellModel = [self pointCellModelWithIndex:index];
    if (!cellModel) {
        return;
    }
    cellModel.timeSpace = timeSpace;
}

/**
 重新设置cell的子控件位置，主要是删除按钮方面的处理
 */
- (void)mk_cellResetFrame {
    [self cellCanSelected];
}

- (void)mk_cellTapAction {
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
    NSMutableArray *scanList = [NSMutableArray array];
    for (NSInteger i = 0; i < self.section2List.count; i ++) {
        MKReportTimePointCellModel *cellModel = self.section2List[i];
        MKScanTimePointModel *pointModel = [[MKScanTimePointModel alloc] init];
        pointModel.hour = cellModel.hour;
        pointModel.minuteGear = cellModel.timeSpace;
        [scanList addObject:pointModel];
    }
    NSMutableArray *reportList = [NSMutableArray array];
    for (NSInteger i = 0; i < self.section4List.count; i ++) {
        MKReportTimePointCellModel *cellModel = self.section4List[i];
        MKScanTimePointModel *pointModel = [[MKScanTimePointModel alloc] init];
        pointModel.hour = cellModel.hour;
        pointModel.minuteGear = cellModel.timeSpace;
        [reportList addObject:pointModel];
    }
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.protocol configScanPointList:scanList reportPointList:reportList sucBlock:^{
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
- (MKReportTimePointCellModel *)pointCellModelWithIndex:(NSInteger)index {
    if (index >= MKTimingReportPointOffset) {
        NSInteger row = index - MKTimingReportPointOffset;
        if (row > self.section4List.count - 1) {
            return nil;
        }
        return self.section4List[row];
    }
    if (index > self.section2List.count - 1) {
        return nil;
    }
    return self.section2List[index];
}

/**
 当有cell右侧的删除按钮出现时，不能触发点击事件
 
 @return YES可点击，NO不可点击
 */
- (BOOL)cellCanSelected{
    BOOL canSelected = YES;
    NSArray *arrCells = [self.tableView visibleCells];
    for (int i = 0; i < [arrCells count]; i++) {
        UITableViewCell *cell = arrCells[i];
        if ([cell isKindOfClass:MKReportTimePointCell.class]) {
            MKReportTimePointCell *tempCell = (MKReportTimePointCell *)cell;
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
    [self loadSection2Datas];
    [self loadSection3Datas];
    [self loadSection4Datas];
    
    for (NSInteger i = 0; i < 5; i ++) {
        MKTableSectionLineHeaderModel *headerModel = [[MKTableSectionLineHeaderModel alloc] init];
        [self.headerList addObject:headerModel];
    }
    
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    MKTextFieldCellModel *cellModel = [[MKTextFieldCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = @"Bluetooth Scan Duration";
    cellModel.msgFont = MKFont(13.f);
    cellModel.textPlaceholder = @"3 ~ 65535";
    cellModel.maxLength = 5;
    cellModel.textFieldType = mk_realNumberOnly;
    cellModel.textFieldValue = self.protocol.duration;
    cellModel.unit = @"s";
    [self.section0List addObject:cellModel];
}

- (void)loadSection1Datas {
    MKTimingModeAddCellModel * cellModel = [[MKTimingModeAddCellModel alloc] init];
    cellModel.msg = @"Bluetooth Scan Time Point";
    [self.section1List addObject:cellModel];
}

- (void)loadSection2Datas {
    for (NSInteger i = 0; i < self.protocol.scanPointList.count; i ++) {
        MKScanTimePointModel *tempModel = self.protocol.scanPointList[i];
        MKReportTimePointCellModel *cellModel = [[MKReportTimePointCellModel alloc] init];
        cellModel.index = i;
        cellModel.msg = [NSString stringWithFormat:@"Time Point %ld",(long)(i + 1)];
        cellModel.hour = tempModel.hour;
        cellModel.timeSpace = tempModel.minuteGear;
        [self.section2List addObject:cellModel];
    }
}

- (void)loadSection3Datas {
    MKTimingModeAddCellModel * cellModel = [[MKTimingModeAddCellModel alloc] init];
    cellModel.msg = @"Report Time Point";
    [self.section3List addObject:cellModel];
}

- (void)loadSection4Datas {
    for (NSInteger i = 0; i < self.protocol.reportPointList.count; i ++) {
        MKScanTimePointModel *tempModel = self.protocol.reportPointList[i];
        MKReportTimePointCellModel *cellModel = [[MKReportTimePointCellModel alloc] init];
        cellModel.index = MKTimingReportPointOffset + i;
        cellModel.msg = [NSString stringWithFormat:@"Time Point %ld",(long)(i + 1)];
        cellModel.hour = tempModel.hour;
        cellModel.timeSpace = tempModel.minuteGear;
        [self.section4List addObject:cellModel];
    }
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Timing Scan & Timing Report";
    [self setNavTitleFont:MKFont(12.f)];
    [self.rightButton setImage:LOADICON(@"MKLoRaCommonModule", @"MKTimingReportController", @"mk_loraDeviceMode_slotSaveIcon.png") forState:UIControlStateNormal];
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

- (MKTimingReportAddCellProxy *)scanAddProxy {
    if (!_scanAddProxy) {
        _scanAddProxy = [[MKTimingReportAddCellProxy alloc] init];
        _scanAddProxy.owner = self;
        _scanAddProxy.type = 0;
    }
    return _scanAddProxy;
}

- (MKTimingReportAddCellProxy *)reportAddProxy {
    if (!_reportAddProxy) {
        _reportAddProxy = [[MKTimingReportAddCellProxy alloc] init];
        _reportAddProxy.owner = self;
        _reportAddProxy.type = 1;
    }
    return _reportAddProxy;
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

- (NSMutableArray *)section4List {
    if (!_section4List) {
        _section4List = [NSMutableArray array];
    }
    return _section4List;
}

- (NSMutableArray *)headerList {
    if (!_headerList) {
        _headerList = [NSMutableArray array];
    }
    return _headerList;
}

@end
