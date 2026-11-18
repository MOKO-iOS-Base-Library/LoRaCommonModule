//
//  MKLoRaDownlinkController.m
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/18.
//

#import "MKLoRaDownlinkController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"
#import "MKTextButtonCell.h"

@interface MKLoRaDownlinkController ()<UITableViewDelegate,
UITableViewDataSource,
MKTextButtonCellDelegate>

@property (nonatomic, strong) MKBaseTableView *tableView;

@property (nonatomic, strong) NSMutableArray *section0List;

@end

@implementation MKLoRaDownlinkController

- (void)dealloc {
    NSLog(@"MKLoRaDownlinkController销毁");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self loadSectionDatas];
    [self readDataFromDevice];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.section0List.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:tableView];
    cell.dataModel = self.section0List[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - MKTextButtonCellDelegate
- (void)mk_loraTextButtonCellSelected:(NSInteger)index
                        dataListIndex:(NSInteger)dataListIndex
                                value:(NSString *)value {
    if (index == 0) {
        [self configDownlinkForPositioningStrategy:dataListIndex];
    }
}

#pragma mark - interface
- (void)readDataFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.protocol readDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self updateCellValues];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)configDownlinkForPositioningStrategy:(NSInteger)strategy {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    self.protocol.positioningStrategy = strategy;
    @weakify(self);
    [self.protocol configDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        MKTextButtonCellModel *cellModel = self.section0List[0];
        cellModel.dataListIndex = strategy;
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        [self.tableView reloadData];
    }];
}

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    MKTextButtonCellModel *cellModel = [[MKTextButtonCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = @"Positioning Strategy";
    cellModel.dataList = [self strategyDataList];
    [self.section0List addObject:cellModel];
}

- (void)updateCellValues {
    MKTextButtonCellModel *cellModel = self.section0List[0];
    cellModel.dataListIndex = self.protocol.positioningStrategy;
    [self.tableView reloadData];
}

#pragma mark - Subclass Override
- (NSArray<NSString *> *)strategyDataList {
    if ([self.protocol respondsToSelector:@selector(strategyDataList)]
        && [self.protocol strategyDataList]) {
        return [self.protocol strategyDataList];
    }
    return @[@"BLE",@"GPS",@"BLE+GPS",@"BLE*GPS"];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Downlink For Position";
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

@end
