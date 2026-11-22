//
//  MKLoRaBXPButtonContentController.m
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/18.
//

#import "MKLoRaBXPButtonContentController.h"
#import "Pages/PayloadContentSelections/BXPButtonContentPage/Protocol/MKLoRaBXPButtonContentPageProtocol.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"

#import "MKHudManager.h"
#import "MKTextSwitchCell.h"

@interface MKLoRaBXPButtonContentController ()<UITableViewDelegate,
UITableViewDataSource,
mk_textSwitchCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@end

@implementation MKLoRaBXPButtonContentController

- (void)dealloc {
    NSLog(@"MKLoRaBXPButtonContentController销毁");
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
        //Frame Type
        self.protocol.frameType = isOn;
        MKTextSwitchCellModel *cellModel = self.dataList[0];
        cellModel.isOn = isOn;
        return;
    }
    if (index == 1) {
        //Status Flag
        self.protocol.statusFlag = isOn;
        MKTextSwitchCellModel *cellModel = self.dataList[1];
        cellModel.isOn = isOn;
        return;
    }
    if (index == 2) {
        //Trigger Count
        self.protocol.triggerCount = isOn;
        MKTextSwitchCellModel *cellModel = self.dataList[2];
        cellModel.isOn = isOn;
        return;
    }
    if (index == 3) {
        //Device ID
        self.protocol.deviceID = isOn;
        MKTextSwitchCellModel *cellModel = self.dataList[3];
        cellModel.isOn = isOn;
        return;
    }
    if (index == 4) {
        //Firmware Type
        self.protocol.firmwareType = isOn;
        MKTextSwitchCellModel *cellModel = self.dataList[4];
        cellModel.isOn = isOn;
        return;
    }
    if (index == 5) {
        //Device Name
        self.protocol.deviceName = isOn;
        MKTextSwitchCellModel *cellModel = self.dataList[5];
        cellModel.isOn = isOn;
        return;
    }
    if (index == 6) {
        //Full Scale
        self.protocol.fullScale = isOn;
        MKTextSwitchCellModel *cellModel = self.dataList[6];
        cellModel.isOn = isOn;
        return;
    }
    if (index == 7) {
        //Motion Threshold
        self.protocol.motionThreshold = isOn;
        MKTextSwitchCellModel *cellModel = self.dataList[7];
        cellModel.isOn = isOn;
        return;
    }
    if (index == 8) {
        //3-axis Data
        self.protocol.axisData = isOn;
        MKTextSwitchCellModel *cellModel = self.dataList[8];
        cellModel.isOn = isOn;
        return;
    }
    if (index == 9) {
        //Temperature
        self.protocol.temperature = isOn;
        MKTextSwitchCellModel *cellModel = self.dataList[9];
        cellModel.isOn = isOn;
        return;
    }
    if (index == 10) {
        //Ranging Data
        self.protocol.rangingData = isOn;
        MKTextSwitchCellModel *cellModel = self.dataList[10];
        cellModel.isOn = isOn;
        return;
    }
    if (index == 11) {
        //Battery Voltage
        self.protocol.battery = isOn;
        MKTextSwitchCellModel *cellModel = self.dataList[11];
        cellModel.isOn = isOn;
        return;
    }
    if (index == 12) {
        //Tx Power
        self.protocol.txPower = isOn;
        MKTextSwitchCellModel *cellModel = self.dataList[12];
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
    cellModel1.msg = @"Frame Type";
    cellModel1.isOn = self.protocol.frameType;
    [self.dataList addObject:cellModel1];
    
    MKTextSwitchCellModel *cellModel2 = [[MKTextSwitchCellModel alloc] init];
    cellModel2.index = 1;
    cellModel2.msg = @"Status Flag";
    cellModel2.isOn = self.protocol.statusFlag;
    [self.dataList addObject:cellModel2];
    
    MKTextSwitchCellModel *cellModel3 = [[MKTextSwitchCellModel alloc] init];
    cellModel3.index = 2;
    cellModel3.msg = @"Trigger Count";
    cellModel3.isOn = self.protocol.triggerCount;
    [self.dataList addObject:cellModel3];
    
    MKTextSwitchCellModel *cellModel4 = [[MKTextSwitchCellModel alloc] init];
    cellModel4.index = 3;
    cellModel4.msg = @"Device ID";
    cellModel4.isOn = self.protocol.deviceID;
    [self.dataList addObject:cellModel4];
    
    MKTextSwitchCellModel *cellModel5 = [[MKTextSwitchCellModel alloc] init];
    cellModel5.index = 4;
    cellModel5.msg = @"Firmware Type";
    cellModel5.isOn = self.protocol.firmwareType;
    [self.dataList addObject:cellModel5];
    
    MKTextSwitchCellModel *cellModel6 = [[MKTextSwitchCellModel alloc] init];
    cellModel6.index = 5;
    cellModel6.msg = @"Device Name";
    cellModel6.isOn = self.protocol.deviceName;
    [self.dataList addObject:cellModel6];
    
    MKTextSwitchCellModel *cellModel7 = [[MKTextSwitchCellModel alloc] init];
    cellModel7.index = 6;
    cellModel7.msg = @"Full Scale";
    cellModel7.isOn = self.protocol.fullScale;
    [self.dataList addObject:cellModel7];
    
    MKTextSwitchCellModel *cellModel8 = [[MKTextSwitchCellModel alloc] init];
    cellModel8.index = 7;
    cellModel8.msg = @"Motion Threshold";
    cellModel8.isOn = self.protocol.motionThreshold;
    [self.dataList addObject:cellModel8];
    
    MKTextSwitchCellModel *cellModel9 = [[MKTextSwitchCellModel alloc] init];
    cellModel9.index = 8;
    cellModel9.msg = @"3-axis Data";
    cellModel9.isOn = self.protocol.axisData;
    [self.dataList addObject:cellModel9];
    
    MKTextSwitchCellModel *cellModel10 = [[MKTextSwitchCellModel alloc] init];
    cellModel10.index = 9;
    cellModel10.msg = @"Temperature";
    cellModel10.isOn = self.protocol.temperature;
    [self.dataList addObject:cellModel10];
    
    MKTextSwitchCellModel *cellModel11 = [[MKTextSwitchCellModel alloc] init];
    cellModel11.index = 10;
    cellModel11.msg = @"Ranging Data";
    cellModel11.isOn = self.protocol.rangingData;
    [self.dataList addObject:cellModel11];
    
    MKTextSwitchCellModel *cellModel12 = [[MKTextSwitchCellModel alloc] init];
    cellModel12.index = 11;
    cellModel12.msg = @"Battery Voltage";
    cellModel12.isOn = self.protocol.battery;
    [self.dataList addObject:cellModel12];
    
    MKTextSwitchCellModel *cellModel13 = [[MKTextSwitchCellModel alloc] init];
    cellModel13.index = 12;
    cellModel13.msg = @"Tx Power";
    cellModel13.isOn = self.protocol.txPower;
    [self.dataList addObject:cellModel13];
    
    [self.tableView reloadData];
}

#pragma mark - UI
- (void)loadSubViews {
    [self.rightButton setImage:LOADICON(@"MKLoRaCommonModule", @"MKLoRaBXPButtonContentController", @"mk_loraModule_loraDeviceMode_slotSaveIcon.png") forState:UIControlStateNormal];
    self.defaultTitle = @"BXP-Button Content";
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
