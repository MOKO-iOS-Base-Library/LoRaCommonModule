#import "MKTofContentController.h"
#import "MKTofContentPageProtocol.h"
#import "Masonry.h"
#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"
#import "MKHudManager.h"
#import "MKTextSwitchCell.h"

@interface MKTofContentController ()<UITableViewDelegate,UITableViewDataSource,mk_textSwitchCellDelegate>
@property (nonatomic, strong)MKBaseTableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataList;
@end

@implementation MKTofContentController
- (void)dealloc { NSLog(@"MKTofContentController销毁"); }
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
    NSArray *keys = @"MFG Code",@"mfg",@"Beacon Code",@"beacon",@"Battery Voltage",@"battery",@"Ranging Distance",@"ranging",@"User Data",@"user",@"Sub Type",@"subType",@"Device Name",@"deviceName";
    if (index >= 0 && index < keys.count) {
        NSString *key = keys[index];
        [self.protocol setValue:@(isOn) forKey:key];
        MKTextSwitchCellModel *cellModel = self.dataList[index];
        cellModel.isOn = isOn;
    }
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
    NSArray *titles = @"MFG Code",@"mfg",@"Beacon Code",@"beacon",@"Battery Voltage",@"battery",@"Ranging Distance",@"ranging",@"User Data",@"user",@"Sub Type",@"subType",@"Device Name",@"deviceName";
    NSArray *keys = @"MFG Code",@"mfg",@"Beacon Code",@"beacon",@"Battery Voltage",@"battery",@"Ranging Distance",@"ranging",@"User Data",@"user",@"Sub Type",@"subType",@"Device Name",@"deviceName";
    // titles 和 keys 是同一个数组，用 index/2 取 label，index%2 取 key 的方式
    NSArray *allItems = @[@"MFG Code",@"mfg",@"Beacon Code",@"beacon",@"Battery Voltage",@"battery",@"Ranging Distance",@"ranging",@"User Data",@"user",@"Sub Type",@"subType",@"Device Name",@"deviceName"];
    for (NSInteger i = 0; i < allItems.count; i += 2) {
        MKTextSwitchCellModel *m = [[MKTextSwitchCellModel alloc] init];
        m.index = i/2; m.msg = allItems[i];
        m.isOn = [[self.protocol valueForKey:allItems[i+1]] boolValue];
        [self.dataList addObject:m];
    }
    [self.tableView reloadData];
}
- (void)loadSubViews {
    self.defaultTitle = @"MK-TOF Content";
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
