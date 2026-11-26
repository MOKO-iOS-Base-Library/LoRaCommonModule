//
//  MKLoRaDeviceModeController.m
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/26.
//

#import "MKLoRaDeviceModeController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"

#import "MKHudManager.h"
#import "MKNormalTextCell.h"
#import "MKTextButtonCell.h"

@interface MKLoRaDeviceModeController ()<UITableViewDelegate,
UITableViewDataSource,
MKTextButtonCellDelegate>

@property (nonatomic, strong) MKBaseTableView *tableView;

@property (nonatomic, strong) NSMutableArray *section0List;

@property (nonatomic, strong) NSMutableArray *section1List;

@end

@implementation MKLoRaDeviceModeController

- (void)dealloc {
    NSLog(@"MKLoRaDeviceModeController销毁");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self readDataFromDevice];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self loadSectionDatas];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 1) {
        return;
    }
    if (![self.protocol respondsToSelector:@selector(deviceModeSubPageViewControllers)]) {
        return;
    }
    NSArray <UIViewController *> *vcList = [self.protocol deviceModeSubPageViewControllers];
    if (indexPath.row >= vcList.count) {
        return;
    }
    [self.navigationController pushViewController:vcList[indexPath.row] animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.section0List.count;
    }
    return self.section1List.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
    cell.dataModel = self.section1List[indexPath.row];
    return cell;
}

#pragma mark - MKTextButtonCellDelegate

- (void)mk_loraTextButtonCellSelected:(NSInteger)index
                        dataListIndex:(NSInteger)dataListIndex
                                value:(NSString *)value {
    if (index == 0) {
        // Device Mode
        [self saveWorkModeToDevice:dataListIndex];
        return;
    }
}

#pragma mark - interface

- (void)readDataFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.protocol readWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self updateDeviceMode:self.protocol.mode];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)saveWorkModeToDevice:(NSInteger)mode {
    self.protocol.mode = mode;
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.protocol configModeWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self updateDeviceMode:mode];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        [self.tableView mk_reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
    }];
}

#pragma mark - updateCellValues

- (void)updateDeviceMode:(NSInteger)mode {
    if (!self.section0List.count) {
        return;
    }
    MKTextButtonCellModel *cellModel = self.section0List[0];
    cellModel.dataListIndex = mode;
    [self.tableView mk_reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - loadSectionDatas

- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadSection1Datas];
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    NSArray <NSString *> *dataList = nil;
    if ([self.protocol respondsToSelector:@selector(deviceModeDataList)]) {
        dataList = [self.protocol deviceModeDataList];
    }
    if (!dataList.count) {
        dataList = @[@"Standby Mode", @"Timing Mode", @"Periodic Mode", @"Motion Mode"];
    }
    MKTextButtonCellModel *cellModel = [[MKTextButtonCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = @"Device Mode";
    cellModel.dataList = dataList;
    cellModel.dataListIndex = self.protocol.mode;
    [self.section0List addObject:cellModel];
}

- (void)loadSection1Datas {
    if (![self.protocol respondsToSelector:@selector(deviceModeSubPageTitles)]) {
        return;
    }
    NSArray <NSString *> *titles = [self.protocol deviceModeSubPageTitles];
    for (NSInteger i = 0; i < titles.count; i ++) {
        MKNormalTextCellModel *cellModel = [[MKNormalTextCellModel alloc] init];
        cellModel.leftMsg = titles[i];
        cellModel.showRightIcon = YES;
        [self.section1List addObject:cellModel];
    }
}

#pragma mark - UI

- (void)loadSubViews {
    self.defaultTitle = @"Device Mode";
    if ([self.protocol respondsToSelector:@selector(deviceModePageTitle)]) {
        NSString *title = [self.protocol deviceModePageTitle];
        if (ValidStr(title)) {
            self.defaultTitle = title;
        }
    }
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

@end
