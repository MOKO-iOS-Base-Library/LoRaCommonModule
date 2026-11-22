//
//  MKLoRaBXPTagContentController.m
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/18.
//

#import "MKLoRaBXPTagContentController.h"
#import "Pages/PayloadContentSelections/BXPTagContentPage/Protocol/MKLoRaBXPTagContentPageProtocol.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"

#import "MKHudManager.h"
#import "MKTextSwitchCell.h"

@interface MKLoRaBXPTagContentController ()<UITableViewDelegate,
UITableViewDataSource,
mk_textSwitchCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@end

@implementation MKLoRaBXPTagContentController

- (void)dealloc {
    NSLog(@"MKLoRaBXPTagContentController销毁");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self readDatasFromDevice];
}

#pragma mark - super method
- (void)rightButtonMethod {
    [self saveDataToDevice];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKTextSwitchCell *cell = [MKTextSwitchCell initCellWithTableView:tableView];
    cell.dataModel = self.dataList[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - mk_textSwitchCellDelegate
- (void)mk_textSwitchCellStatusChanged:(BOOL)isOn index:(NSInteger)index {
    if (index == 0) {
        //Sensor Status
        self.protocol.sensorStatus = isOn;
        MKTextSwitchCellModel *cellModel = self.dataList[0];
        cellModel.isOn = isOn;
        return;
    }
    if (index == 1) {
        //Hall Trigger Event Count
        self.protocol.hallCount = isOn;
        MKTextSwitchCellModel *cellModel = self.dataList[1];
        cellModel.isOn = isOn;
        return;
    }
    if (index == 2) {
        //Motion Trigger Event Count
        self.protocol.motionCount = isOn;
        MKTextSwitchCellModel *cellModel = self.dataList[2];
        cellModel.isOn = isOn;
        return;
    }
    if (index == 3) {
        //3-axis Data
        self.protocol.axisData = isOn;
        MKTextSwitchCellModel *cellModel = self.dataList[3];
        cellModel.isOn = isOn;
        return;
    }
    if (index == 4) {
        //Temperature
        self.protocol.temperature = isOn;
        MKTextSwitchCellModel *cellModel = self.dataList[4];
        cellModel.isOn = isOn;
        return;
    }
    if (index == 5) {
        //Humidity
        self.protocol.humidity = isOn;
        MKTextSwitchCellModel *cellModel = self.dataList[5];
        cellModel.isOn = isOn;
        return;
    }
    if (index == 6) {
        //Battery Voltage
        self.protocol.battery = isOn;
        MKTextSwitchCellModel *cellModel = self.dataList[6];
        cellModel.isOn = isOn;
        return;
    }
    if (index == 7) {
        //Tag ID
        self.protocol.tagID = isOn;
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

#pragma mark - interface
- (void)readDatasFromDevice {
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
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success"];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    MKTextSwitchCellModel *cellModel1 = [[MKTextSwitchCellModel alloc] init];
    cellModel1.index = 0;
    cellModel1.msg = @"Sensor Status";
    cellModel1.isOn = self.protocol.sensorStatus;
    [self.dataList addObject:cellModel1];
    
    MKTextSwitchCellModel *cellModel2 = [[MKTextSwitchCellModel alloc] init];
    cellModel2.index = 1;
    cellModel2.msg = @"Hall Trigger Event Count";
    cellModel2.isOn = self.protocol.hallCount;
    [self.dataList addObject:cellModel2];
    
    MKTextSwitchCellModel *cellModel3 = [[MKTextSwitchCellModel alloc] init];
    cellModel3.index = 2;
    cellModel3.msg = @"Motion Trigger Event Count";
    cellModel3.isOn = self.protocol.motionCount;
    [self.dataList addObject:cellModel3];
    
    MKTextSwitchCellModel *cellModel4 = [[MKTextSwitchCellModel alloc] init];
    cellModel4.index = 3;
    cellModel4.msg = @"3-axis Data";
    cellModel4.isOn = self.protocol.axisData;
    [self.dataList addObject:cellModel4];
    
    MKTextSwitchCellModel *cellModel5 = [[MKTextSwitchCellModel alloc] init];
    cellModel5.index = 4;
    cellModel5.msg = @"Temperature";
    cellModel5.isOn = self.protocol.temperature;
    [self.dataList addObject:cellModel5];
    
    MKTextSwitchCellModel *cellModel6 = [[MKTextSwitchCellModel alloc] init];
    cellModel6.index = 5;
    cellModel6.msg = @"Humidity";
    cellModel6.isOn = self.protocol.humidity;
    [self.dataList addObject:cellModel6];
    
    MKTextSwitchCellModel *cellModel7 = [[MKTextSwitchCellModel alloc] init];
    cellModel7.index = 6;
    cellModel7.msg = @"Battery Voltage";
    cellModel7.isOn = self.protocol.battery;
    [self.dataList addObject:cellModel7];
    
    MKTextSwitchCellModel *cellModel8 = [[MKTextSwitchCellModel alloc] init];
    cellModel8.index = 7;
    cellModel8.msg = @"Tag ID";
    cellModel8.isOn = self.protocol.tagID;
    [self.dataList addObject:cellModel8];
    
    MKTextSwitchCellModel *cellModel9 = [[MKTextSwitchCellModel alloc] init];
    cellModel9.index = 8;
    cellModel9.msg = @"Device Name";
    cellModel9.isOn = self.protocol.deviceName;
    [self.dataList addObject:cellModel9];
    
    [self.tableView reloadData];
}

#pragma mark - UI
- (void)loadSubViews {
    [self.rightButton setImage:LOADICON(@"MKLoRaCommonModule", @"MKLoRaBXPTagContentController", @"mk_loraModule_loraDeviceMode_slotSaveIcon.png") forState:UIControlStateNormal];
    self.defaultTitle = @"BXP-T&S Content";
    [self setNavTitleFont:[UIFont systemFontOfSize:15.f]];
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

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

@end
