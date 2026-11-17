#import "MKLoRaBXPTHContentController.h"
#import "Pages/PayloadContentSelections/BXPTHContentPage/Protocol/MKLoRaBXPTHContentPageProtocol.h"
#import "Masonry.h"
#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"
#import "MKHudManager.h"
#import "MKTextSwitchCell.h"

@interface MKLoRaBXPTHContentController ()<UITableViewDelegate,UITableViewDataSource,mk_textSwitchCellDelegate>
@property (nonatomic, strong)MKBaseTableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataList;
@end

@implementation MKLoRaBXPTHContentController
- (void)dealloc { NSLog(@"MKLoRaBXPTHContentController销毁"); }
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
    if (index == 0) {
        //Tx Power
        self.protocol.txPower = isOn;
        MKTextSwitchCellModel *cellModel = self.dataList[0];
        cellModel.isOn = isOn;
        return;
    }
    if (index == 1) {
        //Ranging Data
        self.protocol.rangingData = isOn;
        MKTextSwitchCellModel *cellModel = self.dataList[1];
        cellModel.isOn = isOn;
        return;
    }
    if (index == 2) {
        //ADV Interval
        self.protocol.advInterval = isOn;
        MKTextSwitchCellModel *cellModel = self.dataList[2];
        cellModel.isOn = isOn;
        return;
    }
    if (index == 3) {
        //Temperature
        self.protocol.temperature = isOn;
        MKTextSwitchCellModel *cellModel = self.dataList[3];
        cellModel.isOn = isOn;
        return;
    }
    if (index == 4) {
        //Humidity
        self.protocol.humidity = isOn;
        MKTextSwitchCellModel *cellModel = self.dataList[4];
        cellModel.isOn = isOn;
        return;
    }
    if (index == 5) {
        //Battery Voltage
        self.protocol.battery = isOn;
        MKTextSwitchCellModel *cellModel = self.dataList[5];
        cellModel.isOn = isOn;
        return;
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
    MKTextSwitchCellModel *cellModel1 = [[MKTextSwitchCellModel alloc] init];
    cellModel1.index = 0;
    cellModel1.msg = @"Tx Power";
    cellModel1.isOn = self.protocol.txPower;
    [self.dataList addObject:cellModel1];
    
    MKTextSwitchCellModel *cellModel2 = [[MKTextSwitchCellModel alloc] init];
    cellModel2.index = 1;
    cellModel2.msg = @"Ranging Data";
    cellModel2.isOn = self.protocol.rangingData;
    [self.dataList addObject:cellModel2];
    
    MKTextSwitchCellModel *cellModel3 = [[MKTextSwitchCellModel alloc] init];
    cellModel3.index = 2;
    cellModel3.msg = @"ADV Interval";
    cellModel3.isOn = self.protocol.advInterval;
    [self.dataList addObject:cellModel3];
    
    MKTextSwitchCellModel *cellModel4 = [[MKTextSwitchCellModel alloc] init];
    cellModel4.index = 3;
    cellModel4.msg = @"Temperature";
    cellModel4.isOn = self.protocol.temperature;
    [self.dataList addObject:cellModel4];
    
    MKTextSwitchCellModel *cellModel5 = [[MKTextSwitchCellModel alloc] init];
    cellModel5.index = 4;
    cellModel5.msg = @"Humidity";
    cellModel5.isOn = self.protocol.humidity;
    [self.dataList addObject:cellModel5];
    
    MKTextSwitchCellModel *cellModel6 = [[MKTextSwitchCellModel alloc] init];
    cellModel6.index = 5;
    cellModel6.msg = @"Battery Voltage";
    cellModel6.isOn = self.protocol.battery;
    [self.dataList addObject:cellModel6];
    
    [self.tableView reloadData];
}
- (void)loadSubViews {
    self.defaultTitle = @"BXP-T&H Content";
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
