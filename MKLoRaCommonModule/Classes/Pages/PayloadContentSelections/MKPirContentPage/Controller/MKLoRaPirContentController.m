#import "MKLoRaPirContentController.h"
#import "Pages/PayloadContentSelections/MKPirContentPage/Protocol/MKLoRaPirContentPageProtocol.h"
#import "Masonry.h"
#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"
#import "MKHudManager.h"
#import "MKTextSwitchCell.h"

@interface MKLoRaPirContentController ()<UITableViewDelegate,UITableViewDataSource,mk_textSwitchCellDelegate>
@property (nonatomic, strong)MKBaseTableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataList;
@end

@implementation MKLoRaPirContentController
- (void)dealloc { NSLog(@"MKLoRaPirContentController销毁"); }
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
        //Pir Delay Response Status
        self.protocol.pirDelayResponse = isOn;
        MKTextSwitchCellModel *cellModel = self.dataList[0];
        cellModel.isOn = isOn;
        return;
    }
    if (index == 1) {
        //Door Open/Close Status
        self.protocol.doorStatus = isOn;
        MKTextSwitchCellModel *cellModel = self.dataList[1];
        cellModel.isOn = isOn;
        return;
    }
    if (index == 2) {
        //Sensor Sensitivity
        self.protocol.sensorSensitivity = isOn;
        MKTextSwitchCellModel *cellModel = self.dataList[2];
        cellModel.isOn = isOn;
        return;
    }
    if (index == 3) {
        //Sensor Detection Status
        self.protocol.sensorDetection = isOn;
        MKTextSwitchCellModel *cellModel = self.dataList[3];
        cellModel.isOn = isOn;
        return;
    }
    if (index == 4) {
        //Battery Voltage
        self.protocol.battery = isOn;
        MKTextSwitchCellModel *cellModel = self.dataList[4];
        cellModel.isOn = isOn;
        return;
    }
    if (index == 5) {
        //Major
        self.protocol.major = isOn;
        MKTextSwitchCellModel *cellModel = self.dataList[5];
        cellModel.isOn = isOn;
        return;
    }
    if (index == 6) {
        //Minor
        self.protocol.minor = isOn;
        MKTextSwitchCellModel *cellModel = self.dataList[6];
        cellModel.isOn = isOn;
        return;
    }
    if (index == 7) {
        //RSSI@1m
        self.protocol.rssi1m = isOn;
        MKTextSwitchCellModel *cellModel = self.dataList[7];
        cellModel.isOn = isOn;
        return;
    }
    if (index == 8) {
        //Device Name
        self.protocol.deviceName = isOn;
        MKTextSwitchCellModel *cellModel = self.dataList[8];
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
    cellModel1.msg = @"PIR Delay Response Status";
    cellModel1.isOn = self.protocol.pirDelayResponse;
    [self.dataList addObject:cellModel1];
    
    MKTextSwitchCellModel *cellModel2 = [[MKTextSwitchCellModel alloc] init];
    cellModel2.index = 1;
    cellModel2.msg = @"Door Open/Close Status";
    cellModel2.isOn = self.protocol.doorStatus;
    [self.dataList addObject:cellModel2];
    
    MKTextSwitchCellModel *cellModel3 = [[MKTextSwitchCellModel alloc] init];
    cellModel3.index = 2;
    cellModel3.msg = @"Sensor Sensitivity";
    cellModel3.isOn = self.protocol.sensorSensitivity;
    [self.dataList addObject:cellModel3];
    
    MKTextSwitchCellModel *cellModel4 = [[MKTextSwitchCellModel alloc] init];
    cellModel4.index = 3;
    cellModel4.msg = @"Sensor Detection Status";
    cellModel4.isOn = self.protocol.sensorDetection;
    [self.dataList addObject:cellModel4];
    
    MKTextSwitchCellModel *cellModel5 = [[MKTextSwitchCellModel alloc] init];
    cellModel5.index = 4;
    cellModel5.msg = @"Battery Voltage";
    cellModel5.isOn = self.protocol.battery;
    [self.dataList addObject:cellModel5];
    
    MKTextSwitchCellModel *cellModel6 = [[MKTextSwitchCellModel alloc] init];
    cellModel6.index = 5;
    cellModel6.msg = @"Major";
    cellModel6.isOn = self.protocol.major;
    [self.dataList addObject:cellModel6];
    
    MKTextSwitchCellModel *cellModel7 = [[MKTextSwitchCellModel alloc] init];
    cellModel7.index = 6;
    cellModel7.msg = @"Minor";
    cellModel7.isOn = self.protocol.minor;
    [self.dataList addObject:cellModel7];
    
    MKTextSwitchCellModel *cellModel8 = [[MKTextSwitchCellModel alloc] init];
    cellModel8.index = 7;
    cellModel8.msg = @"RSSI@1m";
    cellModel8.isOn = self.protocol.rssi1m;
    [self.dataList addObject:cellModel8];
    
    MKTextSwitchCellModel *cellModel9 = [[MKTextSwitchCellModel alloc] init];
    cellModel9.index = 8;
    cellModel9.msg = @"Device Name";
    cellModel9.isOn = self.protocol.deviceName;
    [self.dataList addObject:cellModel9];
    
    [self.tableView reloadData];
}
- (void)loadSubViews {
    [self.rightButton setImage:LOADICON(@"MKLoRaCommonModule", @"MKLoRaPirContentController", @"mk_loraModule_loraDeviceMode_slotSaveIcon@2x.png") forState:UIControlStateNormal];
    self.defaultTitle = @"MK-PIR Content";
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
