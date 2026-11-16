#import "MKBXPBeaconContentController.h"
#import "MKBXPBeaconContentPageProtocol.h"
#import "Masonry.h"
#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"
#import "MKHudManager.h"
#import "MKTextSwitchCell.h"

@interface MKBXPBeaconContentController ()<UITableViewDelegate,UITableViewDataSource,mk_textSwitchCellDelegate>
@property (nonatomic, strong)MKBaseTableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataList;
@end

@implementation MKBXPBeaconContentController
- (void)dealloc { NSLog(@"MKBXPBeaconContentController销毁"); }
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self readDatasFromDevice];
}
- (void)rightButtonMethod { [self saveDataToDevice]; }
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { return 44.f; }
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return self.dataList.count; }
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKTextSwitchCell *cell = [MKTextSwitchCell initCellWithTableView:tableView];
    cell.dataModel = self.dataList[indexPath.row]; cell.delegate = self;
    return cell;
}
- (void)mk_textSwitchCellStatusChanged:(BOOL)isOn index:(NSInteger)index {
    if (index == 0) { self.protocol.uuid = isOn; ((MKTextSwitchCellModel *)self.dataList[0]).isOn = isOn; return; }
    if (index == 1) { self.protocol.major = isOn; ((MKTextSwitchCellModel *)self.dataList[1]).isOn = isOn; return; }
    if (index == 2) { self.protocol.minor = isOn; ((MKTextSwitchCellModel *)self.dataList[2]).isOn = isOn; return; }
    if (index == 3) { self.protocol.measured = isOn; ((MKTextSwitchCellModel *)self.dataList[3]).isOn = isOn; return; }
    if (index == 4) { self.protocol.txPower = isOn; ((MKTextSwitchCellModel *)self.dataList[4]).isOn = isOn; return; }
    if (index == 5) { self.protocol.advInterval = isOn; ((MKTextSwitchCellModel *)self.dataList[5]).isOn = isOn; return; }
}
- (void)readDatasFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.protocol readDataWithSucBlock:^{ @strongify(self); [[MKHudManager share] hide]; [self loadSectionDatas]; }
                             failedBlock:^(NSError * _Nonnull error) {
        @strongify(self); [[MKHudManager share] hide]; [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}
- (void)saveDataToDevice {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.protocol configDataWithSucBlock:^{ @strongify(self); [[MKHudManager share] hide]; [self.view showCentralToast:@"Success"]; }
                               failedBlock:^(NSError * _Nonnull error) {
        @strongify(self); [[MKHudManager share] hide]; [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}
- (void)loadSectionDatas {
    NSArray *items = @[
        @[@"UUID", @"uuid"], @[@"Major", @"major"], @[@"Minor", @"minor"],
        @[@"Measured RSSI@1M", @"measured"], @[@"TX Power", @"txPower"], @[@"ADV Interval", @"advInterval"]
    ];
    for (NSInteger i = 0; i < items.count; i++) {
        MKTextSwitchCellModel *m = [[MKTextSwitchCellModel alloc] init];
        m.index = i; m.msg = items[i][0];
        m.isOn = [[self.protocol valueForKey:items[i][1]] boolValue];
        [self.dataList addObject:m];
    }
    [self.tableView reloadData];
}
- (void)loadSubViews {
    self.defaultTitle = @"BXP-iBeaocn Content";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.view).offset(kTopBarHeight);
        make.bottom.equalTo(self.view).offset(-kSafeAreaHeight);
    }];
}
- (MKBaseTableView *)tableView {
    if (!_tableView) { _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain]; _tableView.delegate = self; _tableView.dataSource = self; }
    return _tableView;
}
- (NSMutableArray *)dataList { if (!_dataList) { _dataList = [NSMutableArray array]; } return _dataList; }
@end
