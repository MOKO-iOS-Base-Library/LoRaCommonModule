//
//  MKLoRaSettingController.m
//  MKLoRaCommonModule
//
//  Created by aa on 2024/7/2.
//

#import "MKLoRaSettingController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"

#import "MKHudManager.h"
#import "MKTextFieldCell.h"
#import "MKTextButtonCell.h"
#import "MKTextSwitchCell.h"
#import "MKLoRaAdvancedSettingCell.h"
#import "MKLoRaSettingCHCell.h"
#import "MKNormalTextCell.h"
#import "MKTableSectionLineHeader.h"

@interface MKLoRaSettingController ()<UITableViewDelegate,
UITableViewDataSource,
MKTextButtonCellDelegate,
MKTextFieldCellDelegate,
mk_textSwitchCellDelegate,
MKLoRaAdvancedSettingCellDelegate,
MKLoRaSettingCHCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *otaaDataList;

@property (nonatomic, strong)NSMutableArray *abpDataList;

@property (nonatomic, strong)NSMutableArray *section2List;

@property (nonatomic, strong)NSMutableArray *optionsList0;

@property (nonatomic, strong)NSMutableArray *optionsList1;

@property (nonatomic, strong)NSMutableArray *optionsList2;

@property (nonatomic, strong)NSMutableArray *optionsList3;

@property (nonatomic, strong)NSMutableArray *optionsList4;

@property (nonatomic, strong)NSMutableArray *optionsList5;

@property (nonatomic, strong)NSMutableArray *optionsList6;

@property (nonatomic, strong)NSMutableArray *optionsList7;

@property (nonatomic, strong)NSMutableArray *optionsList8;

@property (nonatomic, strong)NSMutableArray *optionsList9;

@property (nonatomic, strong)NSMutableArray *headerList;

@end

@implementation MKLoRaSettingController

- (void)dealloc {
    NSLog(@"MKLoRaSettingController销毁");
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self readDatasFromDevice];
}

#pragma mark - super method
- (void)rightButtonMethod {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.protocol configDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success!"];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //底部需要高级设置
    if (indexPath.section == 3) {
        //Advanced Setting
        return 80.f;
    }
    if (indexPath.section == 4) {
        //CH
        MKLoRaSettingCHCellModel *cellModel = self.optionsList1[indexPath.row];
        return [cellModel cellHeightWithContentWidth:kViewWidth];
    }
    if (indexPath.section == 5) {
        //Duty-cycle
        MKTextSwitchCellModel *cellModel = self.optionsList2[indexPath.row];
        return [cellModel cellHeightWithContentWidth:kViewWidth];
    }
    if (indexPath.section == 6) {
        //DR For Join
        MKTextButtonCellModel *cellModel = self.optionsList3[indexPath.row];
        return [cellModel cellHeightWithContentWidth:kViewWidth];
    }
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 2 || section == 7 || section == 12) {
        return 10.f;
    }
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MKTableSectionLineHeader *headerView = [MKTableSectionLineHeader initHeaderViewWithTableView:tableView];
    headerView.headerModel = self.headerList[section];
    return headerView;
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
        if (self.protocol.modem == 1) {
            //ABP
            return self.abpDataList.count;
        }
        if (self.protocol.modem == 2) {
            //OTAA
            return self.otaaDataList.count;
        }
    }
    if (section == 2) {
        return self.section2List.count;
    }
    //存在高级设置选项
    if (section == 3) {
        return self.optionsList0.count;
    }
    if (!self.protocol.advancedStatus) {
        //高级选项开关关闭状态
        return 0;
    }
    if (section == 4) {
        //CH
        if (self.protocol.region == 1 || self.protocol.region == 5) {
            //AU915、US915
            return self.optionsList1.count;
        }
        return 0;
    }
    if (section == 5) {
        //Duty-cycle
        if (self.protocol.region == 2 || self.protocol.region == 6) {
            //EU868,RU864
            return self.optionsList2.count;
        }
        return 0;
    }
    if (section == 6) {
        //DR For Join
        if (self.protocol.region == 2 || self.protocol.region == 3 || self.protocol.region == 4
            || self.protocol.region == 6) {
            //EU868,KR920, IN865, RU864
            return self.optionsList3.count;
        }
        return 0;
    }
    if (section == 7) {
        //Uplink  Strategy
        return self.optionsList4.count;
    }
    if (section == 8) {
        //ADR
        return self.optionsList5.count;
    }
    if (section == 9) {
        //Transmissions
        return 0;
    }
    if (section == 10) {
        //DR For Payload
        return (self.protocol.adrIsOn ? 0 : self.optionsList7.count);
    }
    if (section == 11) {
        //Max retransmission times
        return 0;
    }
    if (section == 12) {
        //ADR_ACK_LIMIT、ADR_ACK_DELAY
        return self.optionsList9.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        //LoRaWAN Mode
        MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 1) {
        //Dev
        MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
        MKTextFieldCellModel *model = (self.protocol.modem == 1) ? self.abpDataList[indexPath.row] : self.otaaDataList[indexPath.row];
        cell.dataModel = model;
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 2) {
        //Region/Subnet、Device Type、Message Type
        MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:tableView];
        cell.dataModel = self.section2List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 3) {
        //Advanced Setting(Optional)
        MKLoRaAdvancedSettingCell *cell = [MKLoRaAdvancedSettingCell initCellWithTableView:tableView];
        cell.dataModel = self.optionsList0[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 4) {
        //CH
        MKLoRaSettingCHCell *cell = [MKLoRaSettingCHCell initCellWithTableView:tableView];
        cell.dataModel = self.optionsList1[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 5) {
        //Duty-cycle
        MKTextSwitchCell *cell = [MKTextSwitchCell initCellWithTableView:tableView];
        cell.dataModel = self.optionsList2[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 6) {
        //DR For Join
        MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:tableView];
        cell.dataModel = self.optionsList3[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 7) {
        //Uplink  Strategy
        MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
        cell.dataModel = self.optionsList4[indexPath.row];
        return cell;
    }
    if (indexPath.section == 8) {
        //ADR
        MKTextSwitchCell *cell = [MKTextSwitchCell initCellWithTableView:tableView];
        cell.dataModel = self.optionsList5[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 9) {
        //Transmissions
        MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:tableView];
        cell.dataModel = self.optionsList6[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 10) {
        //DR For Payload
        MKLoRaSettingCHCell *cell = [MKLoRaSettingCHCell initCellWithTableView:tableView];
        cell.dataModel = self.optionsList7[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 11) {
        //Max retransmission times
        MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:tableView];
        cell.dataModel = self.optionsList8[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
    cell.dataModel = self.optionsList9[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - MKTextButtonCellDelegate
- (void)mk_loraTextButtonCellSelected:(NSInteger)index
                        dataListIndex:(NSInteger)dataListIndex
                                value:(NSString *)value {
    if (index == 0) {
        //modem
        self.protocol.modem = (dataListIndex + 1);
        MKTextButtonCellModel *modeModel = self.section0List[0];
        modeModel.dataListIndex = dataListIndex;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
    if (index == 1) {
        //region
        self.protocol.region = dataListIndex;
        MKTextButtonCellModel *regionModel = self.section2List[0];
        regionModel.dataListIndex = dataListIndex;
        //刷新了region，如果当前是存在高级设置的，需要同步更新所有的高级设置
        if (self.protocol.needAdvanceSetting) {
            [self regionValueChanged];
        }
        return;
    }
    if (index == 3) {
        //message type
        MKTextButtonCellModel *messageModel = self.section2List[1];
        messageModel.dataListIndex = dataListIndex;
        if (!self.protocol.advancedStatus) {
            //高级设置开关状态关闭
            return;
        }
        //高级设置开关状态打开,Max retransmission times: 数据重传次数，当message type设置为 confirmed 时，此项才显示，否则隐藏
        [self.tableView mk_reloadSection:11 withRowAnimation:UITableViewRowAnimationNone];
        return;
        
    }
    if (index == 4) {
        //DR For Join
        self.protocol.join = dataListIndex;
        MKTextButtonCellModel *classModel = self.optionsList3[0];
        classModel.dataListIndex = dataListIndex;
        return;
    }
    if (index == 5) {
        //Transmissions
        MKTextButtonCellModel *drModel = self.optionsList6[0];
        drModel.dataListIndex = dataListIndex;
        return;
    }
    if (index == 6) {
        //Max retransmission times
        MKTextButtonCellModel *drModel = self.optionsList8[0];
        drModel.dataListIndex = dataListIndex;
        return;
    }
}

#pragma mark - MKTextFieldCellDelegate
- (void)mk_deviceTextCellValueChanged:(NSInteger)index textValue:(NSString *)value {
    if (index == 5) {
        //AppKey
        self.protocol.appKey = value;
        MKTextFieldCellModel *appKeyModel = self.otaaDataList[2];
        appKeyModel.textFieldValue = self.protocol.appKey;
        return;
    }
    if (index == 6) {
        //ADR_ACK_LIMIT
        self.protocol.ackLimit = value;
        MKTextFieldCellModel *cellModel = self.optionsList9[0];
        cellModel.textFieldValue = self.protocol.ackLimit;
        return;
    }
    if (index == 7) {
        //ADR_ACK_DELAY
        self.protocol.ackDelay = value;
        MKTextFieldCellModel *cellModel = self.optionsList9[1];
        cellModel.textFieldValue = self.protocol.ackDelay;
        return;
    }
    MKTextFieldCellModel *abpDataModel = self.abpDataList[index];
    abpDataModel.textFieldValue = value;
    if (index == 0) {
        //DevEUI
        self.protocol.devEUI = value;
        MKTextFieldCellModel *devEUIModel2 = self.otaaDataList[0];
        devEUIModel2.textFieldValue = self.protocol.devEUI;
        return;
    }
    if (index == 1) {
        //AppEUI
        self.protocol.appEUI = value;
        MKTextFieldCellModel *appEUIModel2 = self.otaaDataList[1];
        appEUIModel2.textFieldValue = self.protocol.appEUI;
        return;
    }
    if (index == 2) {
        //DevAddr
        self.protocol.devAddr = value;
        return;
    }
    if (index == 3) {
        //AppSkey
        self.protocol.appSKey = value;
        return;
    }
    if (index == 4) {
        //NwkSkey
        self.protocol.nwkSKey = value;
        return;
    }
    
}

#pragma mark - mk_textSwitchCellDelegate
- (void)mk_textSwitchCellStatusChanged:(BOOL)isOn index:(NSInteger)index {
    if (index == 0) {
        //Duty-cycle
        self.protocol.dutyIsOn = isOn;
        MKTextSwitchCellModel *dutyModel = self.optionsList2[0];
        dutyModel.isOn = self.protocol.dutyIsOn;
        return;
    }
    if (index == 1) {
        //ADR
        self.protocol.adrIsOn = isOn;
        MKTextSwitchCellModel *adrModel = self.optionsList5[0];
        adrModel.isOn = self.protocol.adrIsOn;
        //ADR关闭状态才能显示DR For Payload
        [self.tableView reloadData];
        return;
    }
}

#pragma mark - MKLoRaSettingCHCellDelegate

- (void)mk_loraSetting_chHighValueChanged:(NSString *)value
                              chHighIndex:(NSInteger)chHighIndex
                                cellIndex:(NSInteger)index {
    if (index == 0) {
        //CH
        self.protocol.CHH = [value integerValue];
        MKLoRaSettingCHCellModel *cellModel = self.optionsList1[0];
        cellModel.chHighIndex = chHighIndex;
        cellModel.chLowValueList = [self.protocol CHLValueList];
        return;
    }
    if (index == 1) {
        //DR For Payload
        self.protocol.DRH = [value integerValue];
        MKLoRaSettingCHCellModel *cellModel = self.optionsList7[0];
        cellModel.chHighIndex = chHighIndex;
        cellModel.chLowValueList = [self.protocol DRLValueList];
        
        if (self.protocol.DRH < self.protocol.DRL) {
            cellModel.chLowIndex = cellModel.chLowValueList.count - 1;
            self.protocol.DRL = self.protocol.DRH;
        }
        cellModel.chLowIndex = [self getCurrentDRLIndex];
        
        [self.tableView mk_reloadSection:10 withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
}

- (void)mk_loraSetting_chLowValueChanged:(NSString *)value
                              chLowIndex:(NSInteger)chLowIndex
                               cellIndex:(NSInteger)index {
    if (index == 0) {
        //CH
        self.protocol.CHL = [value integerValue];
        MKLoRaSettingCHCellModel *cellModel = self.optionsList1[0];
        cellModel.chLowIndex = chLowIndex;
        cellModel.chHighValueList = [self.protocol CHHValueList];
        return;
    }
    if (index == 1) {
        //DR For Payload
        self.protocol.DRL = [value integerValue];
        MKLoRaSettingCHCellModel *cellModel = self.optionsList7[0];
        cellModel.chLowIndex = chLowIndex;
        cellModel.chHighValueList = [self.protocol DRHValueList];
        
        if (self.protocol.DRH < self.protocol.DRL) {
            cellModel.chHighIndex = 0;
            self.protocol.DRH = self.protocol.DRL;
        }
        cellModel.chHighIndex = [self getCurrentDRHIndex];
        
        [self.tableView mk_reloadSection:10 withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
}

#pragma mark - MKLoRaAdvancedSettingCellDelegate
- (void)mk_loraSetting_advanceCell_switchStatusChanged:(BOOL)isOn {
    self.protocol.advancedStatus = isOn;
    MKLoRaAdvancedSettingCellModel *cellModel = self.optionsList0[0];
    cellModel.isOn = isOn;
    
    [self.headerList removeAllObjects];
    
    NSInteger sections = (self.protocol.advancedStatus ? 13 : 4);
    for (NSInteger i = 0; i < sections; i ++) {
        MKTableSectionLineHeaderModel *headerModel = [[MKTableSectionLineHeaderModel alloc] init];
        [self.headerList addObject:headerModel];
    }
    
    [self.tableView reloadData];
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

#pragma mark - private method
- (void)regionValueChanged {
    [self.protocol configAdvanceSettingDefaultParams];
    //CH
    MKLoRaSettingCHCellModel *cellModel = self.optionsList1[0];
    cellModel.chLowValueList = [self.protocol CHLValueList];
    cellModel.chLowIndex = [self getCurrentCHLIndex];
    cellModel.chHighValueList = [self.protocol CHHValueList];
    cellModel.chHighIndex = [self getCurrentCHHIndex];
    //Duty-cycle
    MKTextSwitchCellModel *dutyModel = self.optionsList2[0];
    dutyModel.isOn = self.protocol.dutyIsOn;
    //DR For Join
    MKTextButtonCellModel *joinModel = self.optionsList3[0];
    joinModel.dataListIndex = self.protocol.join;
    joinModel.dataList = [self.protocol DRValueList];
    //ADR
    MKTextSwitchCellModel *adrModel = self.optionsList5[0];
    adrModel.isOn = self.protocol.adrIsOn;
    //DR For Payload
    MKLoRaSettingCHCellModel *drModel = self.optionsList7[0];
    drModel.chLowValueList = [self.protocol DRLValueList];
    drModel.chLowIndex = [self getCurrentDRLIndex];
    drModel.chHighValueList = [self.protocol DRHValueList];
    drModel.chHighIndex = [self getCurrentDRHIndex];
        
    [self.tableView reloadData];
}

#pragma mark - loadSections
- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadABPDatas];
    [self loadOTAADatas];
    [self loadSection2Datas];
    
    if (!self.protocol.needAdvanceSetting) {
        for (NSInteger i = 0; i < 3; i ++) {
            MKTableSectionLineHeaderModel *headerModel = [[MKTableSectionLineHeaderModel alloc] init];
            [self.headerList addObject:headerModel];
        }
        
        [self.tableView reloadData];
        return;
    }
    [self loadOptionsList0];
    [self loadOptionsList1];
    [self loadOptionsList2];
    [self loadOptionsList3];
    [self loadOptionsList4];
    [self loadOptionsList5];
    [self loadOptionsList6];
    [self loadOptionsList7];
    [self loadOptionsList8];
    [self loadOptionsList9];
    
    //底部需要高级设置
    NSInteger sections = (self.protocol.advancedStatus ? 13 : 4);
    for (NSInteger i = 0; i < sections; i ++) {
        MKTableSectionLineHeaderModel *headerModel = [[MKTableSectionLineHeaderModel alloc] init];
        [self.headerList addObject:headerModel];
    }
    
    [self.tableView reloadData];
}

#pragma mark - 加载上面那个列表

- (void)loadSection0Datas {
    MKTextButtonCellModel *modeModel = [[MKTextButtonCellModel alloc] init];
    modeModel.index = 0;
    modeModel.msg = @"LoRaWAN Mode";
    modeModel.dataList = @[@"ABP",@"OTAA"];
    modeModel.dataListIndex = (self.protocol.modem - 1);
    modeModel.buttonLabelFont = MKFont(13.f);
    [self.section0List addObject:modeModel];
}

- (void)loadABPDatas {
    MKTextFieldCellModel *devEUIModel = [[MKTextFieldCellModel alloc] init];
    devEUIModel.index = 0;
    devEUIModel.msg = @"DevEUI";
    devEUIModel.textFieldTextFont = MKFont(13.f);
    devEUIModel.textFieldType = mk_hexCharOnly;
    devEUIModel.clearButtonMode = UITextFieldViewModeAlways;
    devEUIModel.maxLength = 16;
    devEUIModel.textFieldValue = self.protocol.devEUI;
    [self.abpDataList addObject:devEUIModel];
    
    MKTextFieldCellModel *appEUIModel = [[MKTextFieldCellModel alloc] init];
    appEUIModel.index = 1;
    appEUIModel.msg = @"AppEUI";
    appEUIModel.textFieldTextFont = MKFont(13.f);
    appEUIModel.textFieldType = mk_hexCharOnly;
    appEUIModel.clearButtonMode = UITextFieldViewModeAlways;
    appEUIModel.maxLength = 16;
    appEUIModel.textFieldValue = self.protocol.appEUI;
    [self.abpDataList addObject:appEUIModel];
    
    MKTextFieldCellModel *devAddrModel = [[MKTextFieldCellModel alloc] init];
    devAddrModel.index = 2;
    devAddrModel.msg = @"DevAddr";
    devAddrModel.textFieldTextFont = MKFont(13.f);
    devAddrModel.textFieldType = mk_hexCharOnly;
    devAddrModel.clearButtonMode = UITextFieldViewModeAlways;
    devAddrModel.maxLength = 8;
    devAddrModel.textFieldValue = self.protocol.devAddr;
    [self.abpDataList addObject:devAddrModel];
    
    MKTextFieldCellModel *appSkeyModel = [[MKTextFieldCellModel alloc] init];
    appSkeyModel.index = 3;
    appSkeyModel.msg = @"AppSkey";
    appSkeyModel.textFieldTextFont = MKFont(13.f);
    appSkeyModel.textFieldType = mk_hexCharOnly;
    appSkeyModel.clearButtonMode = UITextFieldViewModeAlways;
    appSkeyModel.maxLength = 32;
    appSkeyModel.textFieldValue = self.protocol.appSKey;
    [self.abpDataList addObject:appSkeyModel];
    
    MKTextFieldCellModel *nwkSkeyModel = [[MKTextFieldCellModel alloc] init];
    nwkSkeyModel.index = 4;
    nwkSkeyModel.msg = @"NwkSkey";
    nwkSkeyModel.textFieldTextFont = MKFont(13.f);
    nwkSkeyModel.textFieldType = mk_hexCharOnly;
    nwkSkeyModel.clearButtonMode = UITextFieldViewModeAlways;
    nwkSkeyModel.maxLength = 32;
    nwkSkeyModel.textFieldValue = self.protocol.nwkSKey;
    [self.abpDataList addObject:nwkSkeyModel];
}

- (void)loadOTAADatas {
    MKTextFieldCellModel *devEUIModel = [[MKTextFieldCellModel alloc] init];
    devEUIModel.index = 0;
    devEUIModel.msg = @"DevEUI";
    devEUIModel.textFieldTextFont = MKFont(13.f);
    devEUIModel.textFieldType = mk_hexCharOnly;
    devEUIModel.clearButtonMode = UITextFieldViewModeAlways;
    devEUIModel.maxLength = 16;
    devEUIModel.textFieldValue = self.protocol.devEUI;
    [self.otaaDataList addObject:devEUIModel];
    
    MKTextFieldCellModel *appEUIModel = [[MKTextFieldCellModel alloc] init];
    appEUIModel.index = 1;
    appEUIModel.msg = @"AppEUI";
    appEUIModel.textFieldTextFont = MKFont(13.f);
    appEUIModel.textFieldType = mk_hexCharOnly;
    appEUIModel.clearButtonMode = UITextFieldViewModeAlways;
    appEUIModel.maxLength = 16;
    appEUIModel.textFieldValue = self.protocol.appEUI;
    [self.otaaDataList addObject:appEUIModel];
    
    MKTextFieldCellModel *appKeyModel = [[MKTextFieldCellModel alloc] init];
    appKeyModel.index = 5;
    appKeyModel.msg = @"AppKey";
    appKeyModel.textFieldTextFont = MKFont(13.f);
    appKeyModel.textFieldType = mk_hexCharOnly;
    appKeyModel.clearButtonMode = UITextFieldViewModeAlways;
    appKeyModel.maxLength = 32;
    appKeyModel.textFieldValue = self.protocol.appKey;
    [self.otaaDataList addObject:appKeyModel];
}

- (void)loadSection2Datas {
    MKTextButtonCellModel *regionModel = [[MKTextButtonCellModel alloc] init];
    regionModel.index = 1;
    regionModel.msg = @"Region/Subnet";
    regionModel.dataList = @[@"AS923",@"AU915",@"EU868",@"KR920",@"IN865",@"US915",@"RU864",@"AS923-1",@"AS923-2",@"AS923-3",@"AS923-4"];
    regionModel.buttonLabelFont = MKFont(13.f);
    regionModel.dataListIndex = self.protocol.region;
    [self.section2List addObject:regionModel];
}

#pragma mark - 加载底部列表
- (void)loadOptionsList0 {
    MKLoRaAdvancedSettingCellModel *cellModel = [[MKLoRaAdvancedSettingCellModel alloc] init];
    cellModel.isOn = self.protocol.advancedStatus;
    [self.optionsList0 addObject:cellModel];
}

- (void)loadOptionsList1 {
    MKLoRaSettingCHCellModel *cellModel = [[MKLoRaSettingCHCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = @"CH";
    cellModel.noteMsg = @"*It is only used for US915,AU915";
    cellModel.noteMsgColor = RGBCOLOR(102, 102, 102);
    cellModel.chLowValueList = [self.protocol CHLValueList];
    cellModel.chLowIndex = [self getCurrentCHLIndex];
    cellModel.chHighValueList = [self.protocol CHHValueList];
    cellModel.chHighIndex = [self getCurrentCHHIndex];
    [self.optionsList1 addObject:cellModel];
}

- (void)loadOptionsList2 {
    MKTextSwitchCellModel *dutyModel = [[MKTextSwitchCellModel alloc] init];
    dutyModel.index = 0;
    dutyModel.msg = @"Duty-cycle";
    dutyModel.noteMsg = @"*It is only used for EU868 and RU864. Off: The uplink report interval will not be limit by region freqency. On:The uplink report interval will be limit by region freqency.";
    dutyModel.noteMsgColor = RGBCOLOR(102, 102, 102);
    dutyModel.isOn = self.protocol.dutyIsOn;
    [self.optionsList2 addObject:dutyModel];
}

- (void)loadOptionsList3 {
    MKTextButtonCellModel *joinModel = [[MKTextButtonCellModel alloc] init];
    joinModel.index = 4;
    joinModel.msg = @"DR For Join";
    joinModel.dataList = [self.protocol DRValueList];
    joinModel.buttonLabelFont = MKFont(13.f);
    joinModel.dataListIndex = self.protocol.join;
    joinModel.noteMsg = @"*It is only used for EU868,KR920, IN865, RU864.";
    joinModel.noteMsgColor = RGBCOLOR(102, 102, 102);
    [self.optionsList3 addObject:joinModel];
}

- (void)loadOptionsList4 {
    MKNormalTextCellModel *cellModel = [[MKNormalTextCellModel alloc] init];
    cellModel.leftMsg = @"Uplink Strategy";
    [self.optionsList4 addObject:cellModel];
}

- (void)loadOptionsList5 {
    MKTextSwitchCellModel *adrModel = [[MKTextSwitchCellModel alloc] init];
    adrModel.index = 1;
    adrModel.msg = @"ADR";
    adrModel.isOn = self.protocol.adrIsOn;
    [self.optionsList5 addObject:adrModel];
}

- (void)loadOptionsList6 {
    MKTextButtonCellModel *transmissionModel = [[MKTextButtonCellModel alloc] init];
    transmissionModel.index = 5;
    transmissionModel.msg = @"Transmissions";
    transmissionModel.dataList = @[@"1",@"2"];
    transmissionModel.buttonLabelFont = MKFont(13.f);
    [self.optionsList6 addObject:transmissionModel];
}

- (void)loadOptionsList7 {
    MKLoRaSettingCHCellModel *cellModel = [[MKLoRaSettingCHCellModel alloc] init];
    cellModel.index = 1;
    cellModel.msg = @"DR For Payload";
    cellModel.chLowValueList = [self.protocol DRLValueList];
    cellModel.chLowIndex = [self getCurrentDRLIndex];
    cellModel.chHighValueList = [self.protocol DRHValueList];
    cellModel.chHighIndex = [self getCurrentDRHIndex];
    [self.optionsList7 addObject:cellModel];
}

- (void)loadOptionsList8 {
    MKTextButtonCellModel *retransmissionModel = [[MKTextButtonCellModel alloc] init];
    retransmissionModel.index = 6;
    retransmissionModel.msg = @"Max retransmission times";
    retransmissionModel.dataList = @[@"0",@"1",@"2",@"3"];
    retransmissionModel.buttonLabelFont = MKFont(13.f);
    [self.optionsList8 addObject:retransmissionModel];
}

- (void)loadOptionsList9 {
    MKTextFieldCellModel *cellModel1 = [[MKTextFieldCellModel alloc] init];
    cellModel1.index = 6;
    cellModel1.msg = @"ADR_ACK_LIMIT";
    cellModel1.textFieldType = mk_realNumberOnly;
    cellModel1.textPlaceholder = @"1-255";
    cellModel1.maxLength = 3;
    cellModel1.textFieldValue = self.protocol.ackLimit;
    [self.optionsList9 addObject:cellModel1];
    
    MKTextFieldCellModel *cellModel2 = [[MKTextFieldCellModel alloc] init];
    cellModel2.index = 7;
    cellModel2.msg = @"ADR_ACK_DELAY";
    cellModel2.textFieldType = mk_realNumberOnly;
    cellModel2.textPlaceholder = @"1-255";
    cellModel2.maxLength = 3;
    cellModel2.textFieldValue = self.protocol.ackDelay;
    [self.optionsList9 addObject:cellModel2];
}

- (NSInteger)getCurrentCHLIndex {
    NSInteger index = 0;
    for (NSInteger i = 0; i < [[self.protocol CHLValueList] count]; i ++) {
        if (self.protocol.CHL == [[self.protocol CHLValueList][i] integerValue]) {
            index = i;
            break;
        }
    }
    return index;
}

- (NSInteger)getCurrentCHHIndex {
    NSInteger index = 0;
    for (NSInteger i = 0; i < [[self.protocol CHHValueList] count]; i ++) {
        if (self.protocol.CHH == [[self.protocol CHHValueList][i] integerValue]) {
            index = i;
            break;
        }
    }
    return index;
}

- (NSInteger)getCurrentDRLIndex {
    NSInteger index = 0;
    for (NSInteger i = 0; i < [[self.protocol DRLValueList] count]; i ++) {
        if (self.protocol.DRL == [[self.protocol DRLValueList][i] integerValue]) {
            index = i;
            break;
        }
    }
    return index;
}

- (NSInteger)getCurrentDRHIndex {
    NSInteger index = 0;
    for (NSInteger i = 0; i < [[self.protocol DRHValueList] count]; i ++) {
        if (self.protocol.DRH == [[self.protocol DRHValueList][i] integerValue]) {
            index = i;
            break;
        }
    }
    return index;
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Connection Settings";
    [self.rightButton setImage:LOADICON(@"MKLoRaCommonModule", @"MKLoRaSettingController", @"mk_loraModule_loraDeviceMode_slotSaveIcon.png") forState:UIControlStateNormal];
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
        
        _tableView.backgroundColor = RGBCOLOR(242, 242, 242);
    }
    return _tableView;
}

- (NSMutableArray *)section0List {
    if (!_section0List) {
        _section0List = [NSMutableArray array];
    }
    return _section0List;
}

- (NSMutableArray *)otaaDataList {
    if (!_otaaDataList) {
        _otaaDataList = [NSMutableArray array];
    }
    return _otaaDataList;
}

- (NSMutableArray *)abpDataList {
    if (!_abpDataList) {
        _abpDataList = [NSMutableArray array];
    }
    return _abpDataList;
}

- (NSMutableArray *)section2List {
    if (!_section2List) {
        _section2List = [NSMutableArray array];
    }
    return _section2List;
}

- (NSMutableArray *)optionsList0 {
    if (!_optionsList0) {
        _optionsList0 = [NSMutableArray array];
    }
    return _optionsList0;
}

- (NSMutableArray *)optionsList1 {
    if (!_optionsList1) {
        _optionsList1 = [NSMutableArray array];
    }
    return _optionsList1;
}

- (NSMutableArray *)optionsList2 {
    if (!_optionsList2) {
        _optionsList2 = [NSMutableArray array];
    }
    return _optionsList2;
}

- (NSMutableArray *)optionsList3 {
    if (!_optionsList3) {
        _optionsList3 = [NSMutableArray array];
    }
    return _optionsList3;
}

- (NSMutableArray *)optionsList4 {
    if (!_optionsList4) {
        _optionsList4 = [NSMutableArray array];
    }
    return _optionsList4;
}

- (NSMutableArray *)optionsList5 {
    if (!_optionsList5) {
        _optionsList5 = [NSMutableArray array];
    }
    return _optionsList5;
}

- (NSMutableArray *)optionsList6 {
    if (!_optionsList6) {
        _optionsList6 = [NSMutableArray array];
    }
    return _optionsList6;
}

- (NSMutableArray *)optionsList7 {
    if (!_optionsList7) {
        _optionsList7 = [NSMutableArray array];
    }
    return _optionsList7;
}

- (NSMutableArray *)optionsList8 {
    if (!_optionsList8) {
        _optionsList8 = [NSMutableArray array];
    }
    return _optionsList8;
}

- (NSMutableArray *)optionsList9 {
    if (!_optionsList9) {
        _optionsList9 = [NSMutableArray array];
    }
    return _optionsList9;
}

- (NSMutableArray *)headerList {
    if (!_headerList) {
        _headerList = [NSMutableArray array];
    }
    return _headerList;
}

@end
