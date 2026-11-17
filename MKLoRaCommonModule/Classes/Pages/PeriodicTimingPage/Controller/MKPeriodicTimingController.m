//
//  MKPeriodicTimingController.m
//  MKLoRaCommonModule_Example
//
//  Created by aa on 2025/5/11.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import "MKPeriodicTimingController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"

#import "MKHudManager.h"
#import "MKTextFieldCell.h"
#import "MKPickerView.h"
#import "MKTableSectionLineHeader.h"

#import "Models/ScanTimePoint/MKScanTimePointModel.h"

#import "Views/ReportTimePointCell/MKReportTimePointCell.h"
#import "Views/TimingModeAddCell/MKTimingModeAddCell.h"

@interface MKPeriodicTimingController ()<UITableViewDelegate,
UITableViewDataSource,
MKTextFieldCellDelegate,
MKTimingModeAddCellDelegate,
MKReportTimePointCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *section2List;

@property (nonatomic, strong)NSMutableArray *headerList;

@property (nonatomic, strong) dispatch_source_t connectTimer;

@property (nonatomic, assign) NSInteger cmdCount;

@end

@implementation MKPeriodicTimingController

- (void)dealloc {
    NSLog(@"MKPeriodicTimingController销毁");
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
        MKTextFieldCellModel *cellModel = self.section0List[indexPath.row];
        return [cellModel cellHeightWithContentWidth:kViewWidth];
    }
    if (indexPath.section == 1) {
        return 30.f;
    }
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
    if (section == 2) {
        return self.section2List.count;
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
        cell.delegate = self;
        return cell;
    }
    MKReportTimePointCell *cell = [MKReportTimePointCell initCellWithTableView:tableView];
    cell.dataModel = self.section2List[indexPath.row];
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
    if (index == 1) {
        //Bluetooth Scan Interval
        self.protocol.interval = value;
        MKTextFieldCellModel *cellModel = self.section0List[1];
        cellModel.textFieldValue = value;
        return;
    }
}

#pragma mark - MKTimingModeAddCellDelegate
- (void)mk_addButtonPressed {
    if (self.section2List.count >= 24) {
        //最多10组
        [self.view showCentralToast:@"You can set up to 24 time points!"];
        return;
    }
    MKReportTimePointCellModel *cellModel = [[MKReportTimePointCellModel alloc] init];
    cellModel.index = self.section2List.count;
    cellModel.msg = [NSString stringWithFormat:@"Time Point %ld",(long)(self.section2List.count + 1)];
    cellModel.hour = 0;
    cellModel.timeSpace = 0;
    [self.section2List addObject:cellModel];
    
    [self.tableView mk_reloadSection:2 withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - MKReportTimePointCellDelegate

- (void)mk_cellDeleteButtonPressed:(NSInteger)index {
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
    MKReportTimePointCellModel *cellModel = self.section2List[index];
    cellModel.hour = hour;
}

/// 用户选择了时间间隔事件
- (void)mk_timeSpaceButtonPressed:(NSInteger)index timeSpace:(NSInteger)timeSpace {
    if (![self cellCanSelected]) {
        return;
    }
    MKReportTimePointCellModel *cellModel = self.section2List[index];
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
    NSMutableArray *tempList = [NSMutableArray array];
    for (NSInteger i = 0; i < self.section2List.count; i ++) {
        MKReportTimePointCellModel *cellModel = self.section2List[i];
        MKScanTimePointModel *pointModel = [[MKScanTimePointModel alloc] init];
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
    
    for (NSInteger i = 0; i < 3; i ++) {
        MKTableSectionLineHeaderModel *headerModel = [[MKTableSectionLineHeaderModel alloc] init];
        [self.headerList addObject:headerModel];
    }
    
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    MKTextFieldCellModel *cellModel1 = [[MKTextFieldCellModel alloc] init];
    cellModel1.index = 0;
    cellModel1.msg = @"Bluetooth Scan Duration";
    cellModel1.msgFont = MKFont(13.f);
    cellModel1.textPlaceholder = @"3 ~ 65535";
    cellModel1.maxLength = 5;
    cellModel1.textFieldType = mk_realNumberOnly;
    cellModel1.textFieldValue = self.protocol.duration;
    cellModel1.unit = @"s";
    [self.section0List addObject:cellModel1];
    
    MKTextFieldCellModel *cellModel2 = [[MKTextFieldCellModel alloc] init];
    cellModel2.index = 1;
    cellModel2.msg = @"Bluetooth Scan Interval";
    cellModel2.msgFont = MKFont(13.f);
    cellModel2.textPlaceholder = @"3 ~ 65535";
    cellModel2.maxLength = 5;
    cellModel2.textFieldType = mk_realNumberOnly;
    cellModel2.textFieldValue = self.protocol.interval;
    cellModel2.unit = @"s";
    cellModel2.noteMsg = @"*The Bluetooth Scan Interval shouldn't be less than Bluetooth Scan Duration.";
    cellModel2.noteMsgColor = RGBCOLOR(105, 105, 105);
    [self.section0List addObject:cellModel2];
}

- (void)loadSection1Datas {
    MKTimingModeAddCellModel * cellModel = [[MKTimingModeAddCellModel alloc] init];
    cellModel.msg = @"Report Time Point";
    [self.section1List addObject:cellModel];
}

- (void)loadSection2Datas {
    for (NSInteger i = 0; i < self.protocol.pointList.count; i ++) {
        MKScanTimePointModel *tempModel = self.protocol.pointList[i];
        MKReportTimePointCellModel *cellModel = [[MKReportTimePointCellModel alloc] init];
        cellModel.index = i;
        cellModel.msg = [NSString stringWithFormat:@"Time Point %ld",(long)(i + 1)];
        cellModel.hour = tempModel.hour;
        cellModel.timeSpace = tempModel.minuteGear;
        [self.section2List addObject:cellModel];
    }
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Periodic Scan & Timing Report";
    [self setNavTitleFont:MKFont(12.f)];
    [self.rightButton setImage:LOADICON(@"MKLoRaCommonModule", @"MKPeriodicTimingController", @"mk_loraDeviceMode_slotSaveIcon.png") forState:UIControlStateNormal];
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

- (NSMutableArray *)headerList {
    if (!_headerList) {
        _headerList = [NSMutableArray array];
    }
    return _headerList;
}

@end
