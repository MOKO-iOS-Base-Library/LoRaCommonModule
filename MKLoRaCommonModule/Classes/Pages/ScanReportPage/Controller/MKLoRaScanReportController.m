//
//  MKLoRaScanReportController.m
//  MKLoRaCommonModule_Example
//
//  Created by aa on 2026/11/18.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import "MKLoRaScanReportController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"
#import "MKTextButtonCell.h"
#import "MKSettingTextCell.h"
#import "MKTableSectionLineHeader.h"

#import "Pages/TimingImmediatelyPage/Controller/MKLoRaTimingImmediatelyController.h"
#import "Pages/PeriodicImmediatelyPage/Controller/MKLoRaPeriodicImmediatelyController.h"
#import "Pages/ScanAlwaysPage/Controller/MKLoRaScanAlwaysController.h"
#import "Pages/PeriodicScanPage/Controller/MKLoRaPeriodicScanController.h"
#import "Pages/ScanTimingPage/Controller/MKLoRaScanTimingController.h"
#import "Pages/TimingReportPage/Controller/MKLoRaTimingReportController.h"
#import "Pages/PeriodicTimingPage/Controller/MKLoRaPeriodicTimingController.h"

@interface MKLoRaScanReportController ()<UITableViewDelegate,
UITableViewDataSource,
MKTextButtonCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *headerList;

@end

@implementation MKLoRaScanReportController

- (void)dealloc {
    NSLog(@"MKLoRaScanReportController销毁");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self readDataFromDevice];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 0) {
        //Timing Scan & Immediately Report
        MKLoRaTimingImmediatelyController *vc = [[MKLoRaTimingImmediatelyController alloc] init];
        vc.protocol = [self childProtocolAtRow:0];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section == 1 && indexPath.row == 1) {
        //Periodic Scan & Immediately Report
        MKLoRaPeriodicImmediatelyController *vc = [[MKLoRaPeriodicImmediatelyController alloc] init];
        vc.protocol = [self childProtocolAtRow:1];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section == 1 && indexPath.row == 2) {
        //Scan Always On & Periodic Report
        MKLoRaScanAlwaysController *vc = [[MKLoRaScanAlwaysController alloc] init];
        vc.protocol = [self childProtocolAtRow:2];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section == 1 && indexPath.row == 3) {
        //Periodic Scan & Periodic Report
        MKLoRaPeriodicScanController *vc = [[MKLoRaPeriodicScanController alloc] init];
        vc.protocol = [self childProtocolAtRow:3];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section == 1 && indexPath.row == 4) {
        //Scan Always On & Timing Report
        MKLoRaScanTimingController *vc = [[MKLoRaScanTimingController alloc] init];
        vc.protocol = [self childProtocolAtRow:4];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section == 1 && indexPath.row == 5) {
        //Timing Scan & Timing Report
        MKLoRaTimingReportController *vc = [[MKLoRaTimingReportController alloc] init];
        vc.protocol = [self childProtocolAtRow:5];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section == 1 && indexPath.row == 6) {
        //Periodic Scan & Timing Report
        MKLoRaPeriodicTimingController *vc = [[MKLoRaPeriodicTimingController alloc] init];
        vc.protocol = [self childProtocolAtRow:6];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
}

#pragma mark - private method
- (id)childProtocolAtRow:(NSInteger)row {
    if ([self.protocol respondsToSelector:@selector(scanReportPageChildProtocolWithRow:)]) {
        return [self.protocol scanReportPageChildProtocolWithRow:row];
    }
    return nil;
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
        MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    MKSettingTextCell *cell = [MKSettingTextCell initCellWithTableView:tableView];
    cell.dataModel = self.section1List[indexPath.row];
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
        //Strategies Selection
        self.protocol.strategy = dataListIndex;
        [self saveDataToDevice];
        return;
    }
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
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.protocol configDataWithSucBlock:^{
        @strongify(self);
        MKTextButtonCellModel *cellModel = self.section0List[0];
        cellModel.dataListIndex = self.protocol.strategy;
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success"];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        MKTextButtonCellModel *cellModel = self.section0List[0];
        self.protocol.strategy = cellModel.dataListIndex;
        [self.tableView reloadData];
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - loadSections
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
    MKTextButtonCellModel *cellModel = [[MKTextButtonCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = @"Strategies Selection";
    cellModel.dataList = @[@"No Scan & No report",@"Timing scan & Immediately report",@"Periodic scan & Immediately report",@"Scan always on & Periodic report",@"Periodic scan & Periodic report",@"Scan always on & Timing report",@"Timing scan & Timing report",@"Periodic scan & Timing report"];
    cellModel.dataListIndex = self.protocol.strategy;
    cellModel.buttonLabelFont = MKFont(12.f);
    [self.section0List addObject:cellModel];
}

- (void)loadSection1Datas {
    MKSettingTextCellModel *cellModel1 = [[MKSettingTextCellModel alloc] init];
    cellModel1.leftMsg = @"Timing Scan & Immediately Report";
    [self.section1List addObject:cellModel1];
    
    MKSettingTextCellModel *cellModel2 = [[MKSettingTextCellModel alloc] init];
    cellModel2.leftMsg = @"Periodic Scan & Immediately Report";
    [self.section1List addObject:cellModel2];
    
    MKSettingTextCellModel *cellModel3 = [[MKSettingTextCellModel alloc] init];
    cellModel3.leftMsg = @"Scan Always On & Periodic Report";
    [self.section1List addObject:cellModel3];
    
    MKSettingTextCellModel *cellModel4 = [[MKSettingTextCellModel alloc] init];
    cellModel4.leftMsg = @"Periodic Scan & Periodic Report";
    [self.section1List addObject:cellModel4];
    
    MKSettingTextCellModel *cellModel5 = [[MKSettingTextCellModel alloc] init];
    cellModel5.leftMsg = @"Scan Always On & Timing Report";
    [self.section1List addObject:cellModel5];
    
    MKSettingTextCellModel *cellModel6 = [[MKSettingTextCellModel alloc] init];
    cellModel6.leftMsg = @"Timing Scan & Timing Report";
    [self.section1List addObject:cellModel6];
    
    MKSettingTextCellModel *cellModel7 = [[MKSettingTextCellModel alloc] init];
    cellModel7.leftMsg = @"Periodic Scan & Timing Report";
    [self.section1List addObject:cellModel7];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Scan&Report Strategies";
    [self setNavTitleFont:MKFont(14.f)];
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
