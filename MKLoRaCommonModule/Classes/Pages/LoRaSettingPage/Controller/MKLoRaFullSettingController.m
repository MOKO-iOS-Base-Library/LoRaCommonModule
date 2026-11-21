//
//  MKLoRaFullSettingController.m
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/18.
//

#import "MKLoRaFullSettingController.h"

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

#import "MKLoRaSettingAccountCell.h"
#import "MKLoRaDevEUICell.h"


@interface MKLoRaFullSettingController ()<UITableViewDelegate,
UITableViewDataSource,
MKTextButtonCellDelegate,
MKTextFieldCellDelegate,
mk_textSwitchCellDelegate,
MKLoRaAdvancedSettingCellDelegate,
MKLoRaSettingCHCellDelegate,
MKLoRaSettingAccountCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

/// LoRaWAN Mode
@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *otaaDataList;

@property (nonatomic, strong)NSMutableArray *abpDataList;

/// mokoDevEUI
@property (nonatomic, strong)NSMutableArray *section1List;

/// Region
@property (nonatomic, strong)NSMutableArray *section2List;

/// Device Type
@property (nonatomic, strong)NSMutableArray *section3List;

/// Message Type
@property (nonatomic, strong)NSMutableArray *section4List;

/// LoRaWAN Server Platform
@property (nonatomic, strong)NSMutableArray *section5List;

/// Account
@property (nonatomic, strong)NSMutableArray *section6List;

/// Gateway EUI(Gateway ID)
@property (nonatomic, strong)NSMutableArray *section7List;

/// Advanced Setting(Optional)
@property (nonatomic, strong)NSMutableArray *optionsList0;

/// CH
@property (nonatomic, strong)NSMutableArray *optionsList1;

/// Duty-cycle
@property (nonatomic, strong)NSMutableArray *optionsList2;

/// DR For Join
@property (nonatomic, strong)NSMutableArray *optionsList3;

/// Uplink Strategy
@property (nonatomic, strong)NSMutableArray *optionsList4;

/// ADR
@property (nonatomic, strong)NSMutableArray *optionsList5;

/// Transmissions
@property (nonatomic, strong)NSMutableArray *optionsList6;

/// DR For Payload
@property (nonatomic, strong)NSMutableArray *optionsList7;

/// Max retransmission times
@property (nonatomic, strong)NSMutableArray *optionsList8;

/// ADR_ACK_LIMIT/ADR_ACK_DELAY
@property (nonatomic, strong)NSMutableArray *optionsList9;

/// EU868 Single Channel Function
@property (nonatomic, strong)NSMutableArray *optionsList10;

/// Single Channel Selection
@property (nonatomic, strong)NSMutableArray *optionsList11;

@property (nonatomic, strong)NSMutableArray *headerList;

@end

@implementation MKLoRaFullSettingController

- (instancetype)initWithProtocol:(id<MKLoRaFullSettingPageProtocol>)protocol {
    if (self = [super init]) {
        _protocol = protocol;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"MKLoRaFullSettingController销毁");
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
    if ([self isStandaloneSetting] || !self.protocol.supportServerPlatform || self.protocol.platform == 0) {
        //不需要跟服务器交互
        [self saveDataToDevice];
        return;
    }
    if (!self.protocol.isLoggedIn) {
        //当前未登录，弹登录弹窗（带环境切换）
        @weakify(self);
        [self.protocol showLoginFromViewController:self completion:^{
            @strongify(self);
            // 登录成功，直接添加设备
            [self addDeviceToCloud];
        }];
        return;
    }
    //已登录，直接添加设备
    [self addDeviceToCloud];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isStandaloneSetting]) {
        return [self standaloneHeightForRowAtIndexPath:indexPath];
    }
    if (indexPath.section == 8) {
        //LoRaWAN Server Platform
        MKTextFieldCellModel *cellModel = self.section7List[indexPath.row];
        return [cellModel cellHeightWithContentWidth:kViewWidth];
    }
    //底部需要高级设置
    if (indexPath.section == 9) {
        //Advanced Setting
        return 80.f;
    }
    if (indexPath.section == 10) {
        //CH
        MKLoRaSettingCHCellModel *cellModel = self.optionsList1[indexPath.row];
        return [cellModel cellHeightWithContentWidth:kViewWidth];
    }
    if (indexPath.section == 11) {
        //Duty-cycle
        MKTextSwitchCellModel *cellModel = self.optionsList2[indexPath.row];
        return [cellModel cellHeightWithContentWidth:kViewWidth];
    }
    if (indexPath.section == 12) {
        //DR For Join
        MKTextButtonCellModel *cellModel = self.optionsList3[indexPath.row];
        return [cellModel cellHeightWithContentWidth:kViewWidth];
    }
    if (indexPath.section == 19) {
        //EU868 Single Channel Function
        MKTextSwitchCellModel *cellModel = self.optionsList10[indexPath.row];
        return [cellModel cellHeightWithContentWidth:kViewWidth];
    }
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self isStandaloneSetting]) {
        return 0.f;
    }
    if (section == 0 && (self.protocol.supportServerPlatform && self.protocol.platform == 0)) {
        //LoRaWAN Mode
        return 10.f;
    }
    if (section == 2 && (self.protocol.supportServerPlatform && self.protocol.platform == 1)) {
        //mokoDevEUI
        return 10.f;
    }
    if (section == 3) {
        //Region
        return 10.f;
    }
    if (section == 4 && self.protocol.supportClassType) {
        //Device Type
        return 10.f;
    }
    if (section == 5 && self.protocol.supportMessageType) {
        //Message Type
        return 10.f;
    }
    if (section == 6 && self.protocol.supportServerPlatform) {
        //LoRaWAN Server Platform
        return 10.f;
    }
    if (section == 7 && (self.protocol.supportServerPlatform && self.protocol.platform == 1)) {
        //Account
        return 10.f;
    }
    if (section == 8 && (self.protocol.supportServerPlatform && self.protocol.platform == 1)) {
        //Gateway EUI(Gateway ID)
        return 10.f;
    }
    if (section == 13 || section == 18 || section == 19) {
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
    if ([self isStandaloneSetting]) {
        return [self standaloneNumberOfRowsInSection:section];
    }
    if (section == 0) {
        return (self.protocol.supportServerPlatform && self.protocol.platform == 0) ? self.section0List.count : 0;
    }
    if (section == 1) {
        if (self.protocol.supportServerPlatform && self.protocol.platform == 1) {
            return 0;
        }
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
        //mokoDevEUI，只有当platform=MOKO IoT DM的时候才有
        return ((self.protocol.supportServerPlatform && self.protocol.platform == 1) ? self.section2List.count : 0);
    }
    if (section == 3) {
        //Region
        return self.section2List.count;
    }
    if (section == 4) {
        //Device Type
        return (self.protocol.supportClassType ? self.section3List.count : 0);
    }
    if (section == 5) {
        //Message Type
        return (self.protocol.supportMessageType ? self.section4List.count : 0);
    }
    if (section == 6) {
        //LoRaWAN Server Platform
        return (self.protocol.supportServerPlatform ? self.section5List.count : 0);
    }
    if (section == 7) {
        //Account
        return ((self.protocol.supportServerPlatform && self.protocol.platform == 1 && self.protocol.isLoggedIn) ? self.section6List.count : 0);
    }
    if (section == 8) {
        //Gateway EUI(Gateway ID)
        return ((self.protocol.supportServerPlatform && self.protocol.platform == 1) ? self.section7List.count : 0);
    }
    //存在高级设置选项
    if (section == 9) {
        return self.optionsList0.count;
    }
    if (!self.protocol.advancedStatus) {
        //高级选项开关关闭状态
        return 0;
    }
    if (section == 10) {
        //CH
        if (self.protocol.currentRegion == 1 || self.protocol.currentRegion == 2 || self.protocol.currentRegion == 8) {
            //US915、AU915、CN470
            return self.optionsList1.count;
        }
        return 0;
    }
    if (section == 11) {
        //Duty-cycle
        if (self.protocol.currentRegion == 3 || self.protocol.currentRegion == 4 || self.protocol.currentRegion == 5 || self.protocol.currentRegion == 9) {
            //EU868,CN779, EU433,RU864
            return self.optionsList2.count;
        }
        return 0;
    }
    if (section == 12) {
        //DR For Join
        if (self.protocol.currentRegion == 2 || self.protocol.currentRegion == 3 || self.protocol.currentRegion == 4
            || self.protocol.currentRegion == 5 || self.protocol.currentRegion == 6 || self.protocol.currentRegion == 7
            || self.protocol.currentRegion == 9) {
            //CN470, CN779, EU433, EU868,KR920, IN865, RU864
            return self.optionsList3.count;
        }
        return 0;
    }
    if (section == 13) {
        //Uplink  Strategy
        return self.optionsList4.count;
    }
    if (section == 14) {
        //ADR
        return self.optionsList5.count;
    }
    if (section == 15) {
        //Transmissions
        BOOL supportTransmissions = YES;
        if ([self.protocol respondsToSelector:@selector(supportTransmissions)]) {
            supportTransmissions = self.protocol.supportTransmissions;
        }
        return ((!supportTransmissions || self.protocol.adrIsOn) ? 0 : self.optionsList6.count);
    }
    if (section == 16) {
        //DR For Payload
        return (self.protocol.adrIsOn ? 0 : self.optionsList7.count);
    }
    if (section == 17) {
        //Max retransmission times
        return ((self.protocol.supportMessageType && self.protocol.supportMaxRetransmissionTimes
                 && self.protocol.messageType == 1) ? self.optionsList8.count : 0);
    }
    if (section == 18) {
        //ADR_ACK_LIMIT、ADR_ACK_DELAY
        return (self.protocol.supportADRACK ? self.optionsList9.count : 0);
    }
    if ([self.protocol respondsToSelector:@selector(supportEU868SingleChannel)]
        && self.protocol.supportEU868SingleChannel && self.protocol.currentRegion == 5) {
        if (section == 19) {
            return self.optionsList10.count;
        }
        if (section == 20) {
            return self.optionsList11.count;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isStandaloneSetting]) {
        return [self standaloneCellForRowAtIndexPath:indexPath tableView:tableView];
    }
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
        //mokoDevEUI
        MKLoRaDevEUICell *cell = [MKLoRaDevEUICell initCellWithTableView:tableView];
        cell.dataModel = self.section1List[indexPath.row];
        return cell;
    }
    if (indexPath.section == 3) {
        //Region/Subnet
        MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:tableView];
        cell.dataModel = self.section2List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 4) {
        //Device Type
        MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:tableView];
        cell.dataModel = self.section3List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 5) {
        //Message Type
        MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:tableView];
        cell.dataModel = self.section4List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 6) {
        //LoRaWAN Server Platform
        MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:tableView];
        cell.dataModel = self.section5List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 7) {
        //Account
        MKLoRaSettingAccountCell *cell = [MKLoRaSettingAccountCell initCellWithTableView:tableView];
        cell.dataModel = self.section6List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 8) {
        //Gateway EUI(Gateway ID)
        MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
        cell.dataModel = self.section7List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 9) {
        //Advanced Setting(Optional)
        MKLoRaAdvancedSettingCell *cell = [MKLoRaAdvancedSettingCell initCellWithTableView:tableView];
        cell.dataModel = self.optionsList0[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 10) {
        //CH
        MKLoRaSettingCHCell *cell = [MKLoRaSettingCHCell initCellWithTableView:tableView];
        cell.dataModel = self.optionsList1[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 11) {
        //Duty-cycle
        MKTextSwitchCell *cell = [MKTextSwitchCell initCellWithTableView:tableView];
        cell.dataModel = self.optionsList2[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 12) {
        //DR For Join
        MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:tableView];
        cell.dataModel = self.optionsList3[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 13) {
        //Uplink  Strategy
        MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
        cell.dataModel = self.optionsList4[indexPath.row];
        return cell;
    }
    if (indexPath.section == 14) {
        //ADR
        MKTextSwitchCell *cell = [MKTextSwitchCell initCellWithTableView:tableView];
        cell.dataModel = self.optionsList5[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 15) {
        //Transmissions
        MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:tableView];
        cell.dataModel = self.optionsList6[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 16) {
        //DR For Payload
        MKLoRaSettingCHCell *cell = [MKLoRaSettingCHCell initCellWithTableView:tableView];
        cell.dataModel = self.optionsList7[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 17) {
        //Max retransmission times
        MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:tableView];
        cell.dataModel = self.optionsList8[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 18) {
        MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
        cell.dataModel = self.optionsList9[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 19) {
        //EU868 Single Channel Function
        MKTextSwitchCell *cell = [MKTextSwitchCell initCellWithTableView:tableView];
        cell.dataModel = self.optionsList10[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    //Single Channel Selection
    MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:tableView];
    cell.dataModel = self.optionsList11[indexPath.row];
    cell.delegate = self;
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
    if ([self isStandaloneSetting]) {
        [self standaloneTextButtonCellSelected:index dataListIndex:dataListIndex];
        return;
    }
    if (index == 0) {
        //modem
        self.protocol.modem = (dataListIndex + 1);
        MKTextButtonCellModel *modeModel = self.section0List[0];
        modeModel.dataListIndex = dataListIndex;
        [self.tableView mk_reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
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
    if (index == 2) {
        //Device type
        self.protocol.classType = dataListIndex;
        MKTextButtonCellModel *regionModel = self.section3List[0];
        regionModel.dataListIndex = dataListIndex;
        return;
    }
    if (index == 3) {
        //Message type
        self.protocol.messageType = dataListIndex;
        MKTextButtonCellModel *regionModel = self.section4List[0];
        regionModel.dataListIndex = dataListIndex;
        [self.tableView mk_reloadSection:17 withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
    if (index == 4) {
        //LoRaWAN Server Platform
        self.protocol.platform = dataListIndex;
        MKTextButtonCellModel *platModel = self.section5List[0];
        platModel.dataListIndex = dataListIndex;

        MKTextButtonCellModel *regionModel = self.section2List[0];
        regionModel.dataList = [self.protocol RegionList];
        regionModel.dataListIndex = 1;
        self.protocol.region = 1;

        [self.tableView reloadData];
        return;
    }
    if (index == 5) {
        //DR For Join
        self.protocol.join = dataListIndex;
        MKTextButtonCellModel *classModel = self.optionsList3[0];
        classModel.dataListIndex = dataListIndex;
        return;
    }
    if (index == 6) {
        //Transmissions
        self.protocol.transmissions = dataListIndex;
        MKTextButtonCellModel *drModel = self.optionsList6[0];
        drModel.dataListIndex = dataListIndex;
        return;
    }
    if (index == 7) {
        //Max retransmission times
        self.protocol.retransmission = dataListIndex;
        MKTextButtonCellModel *drModel = self.optionsList8[0];
        drModel.dataListIndex = dataListIndex;
        return;
    }
    if (index == 8) {
        //Single Channel Selection
        self.protocol.eu868SignleChannel = dataListIndex;
        MKTextButtonCellModel *channelModel = self.optionsList11[0];
        channelModel.dataListIndex = dataListIndex;
        return;
    }
}

#pragma mark - MKTextFieldCellDelegate
- (void)mk_deviceTextCellValueChanged:(NSInteger)index textValue:(NSString *)value {
    if (index == 5) {
        //AppKey
        self.protocol.appKey = value;
        MKTextFieldCellModel *appKeyModel = self.otaaDataList[2];
        appKeyModel.textFieldValue = value;
        return;
    }
    if (index == 6) {
        //Gateway EUI(Gateway ID)
        self.protocol.gatewayEUI = value;
        MKTextFieldCellModel *cellModel = self.section7List[0];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 7) {
        //ADR_ACK_LIMIT
        self.protocol.ackLimit = value;
        MKTextFieldCellModel *cellModel = self.optionsList9[0];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 8) {
        //ADR_ACK_DELAY
        self.protocol.ackDelay = value;
        MKTextFieldCellModel *cellModel = self.optionsList9[1];
        cellModel.textFieldValue = value;
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
    if ([self isStandaloneSetting]) {
        [self standaloneSwitchCellStatusChanged:isOn index:index];
        return;
    }
    if (index == 0) {
        //Duty-cycle
        self.protocol.dutyIsOn = isOn;
        MKTextSwitchCellModel *dutyModel = self.optionsList2[0];
        dutyModel.isOn = isOn;
        return;
    }
    if (index == 1) {
        //ADR
        self.protocol.adrIsOn = isOn;
        MKTextSwitchCellModel *adrModel = self.optionsList5[0];
        adrModel.isOn = isOn;
        //ADR关闭状态才能显示DR For Payload
        [self.tableView reloadData];
        return;
    }
    if (index == 2) {
        //EU868 Single Channel Function
        self.protocol.eu868SignleChannelStatus = isOn;
        MKTextSwitchCellModel *channelStatusModel = self.optionsList10[0];
        channelStatusModel.isOn = isOn;
        return;
    }
}

#pragma mark - MKLoRaSettingCHCellDelegate

/// 选择了右侧高位的列表
/// @param value 当前选中的值
/// @param chHighIndex 当前值在高位列表里面的index
/// @param index 当前cell所在的index
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

        [self.tableView mk_reloadSection:16 withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
}

/// 选择了左侧高\低位的列表
/// @param value 当前选中的值
/// @param chLowIndex 当前值在低位列表里面的index
/// @param index 当前cell所在的index
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

        [self.tableView mk_reloadSection:16 withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
}

#pragma mark - MKLoRaAdvancedSettingCellDelegate
- (void)mk_loraSetting_advanceCell_switchStatusChanged:(BOOL)isOn {
    self.protocol.advancedStatus = isOn;
    MKLoRaAdvancedSettingCellModel *cellModel = self.optionsList0[0];
    cellModel.isOn = isOn;

    [self.headerList removeAllObjects];

    NSInteger advancedSections = ([self.protocol respondsToSelector:@selector(supportEU868SingleChannel)] ? 21 : 19);
    NSInteger sections = (self.protocol.advancedStatus ? advancedSections : 10);
    if ([self isStandaloneSetting]) {
        sections = [self standaloneSectionCount];
    }
    for (NSInteger i = 0; i < sections; i ++) {
        MKTableSectionLineHeaderModel *headerModel = [[MKTableSectionLineHeaderModel alloc] init];
        [self.headerList addObject:headerModel];
    }

    [self.tableView reloadData];
}

#pragma mark - MKLoRaSettingAccountCellDelegate
- (void)mk_loraSettingAccountCell_logoutBtnPressed {
    @weakify(self);
    [self.protocol showLogoutFromViewController:self completion:^{
        @strongify(self);
        // 退出完成，刷新 Account section
        [self.tableView mk_reloadSection:7 withRowAnimation:UITableViewRowAnimationNone];
    }];
}

#pragma mark - interface

- (void)addDeviceToCloud {
    [[MKHudManager share] showHUDWithTitle:@"Loading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.protocol addDeviceToCloudWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self saveDataToDevice];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

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
        [self.view showCentralToast:@"Success!"];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - standalone setting
- (BOOL)isStandaloneSetting {
    return ([self.protocol respondsToSelector:@selector(supportStandaloneSetting)]
            && self.protocol.supportStandaloneSetting);
}

- (NSInteger)standaloneSectionCount {
    if (!self.protocol.needAdvanceSetting) {
        return 3;
    }
    return (self.protocol.advancedStatus ? 9 : 4);
}

- (CGFloat)standaloneHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 2) {
        return 44.f;
    }
    if (indexPath.section == 3 || indexPath.section == 4) {
        return 80.f;
    }
    if (indexPath.section == 5) {
        MKTextSwitchCellModel *cellModel = self.optionsList2[indexPath.row];
        return [cellModel cellHeightWithContentWidth:kViewWidth];
    }
    if (indexPath.section == 7) {
        MKTextButtonCellModel *cellModel = self.optionsList4[indexPath.row];
        return [cellModel cellHeightWithContentWidth:kViewWidth];
    }
    if (indexPath.section == 8) {
        MKTextButtonCellModel *cellModel = self.optionsList5[indexPath.row];
        return [cellModel cellHeightWithContentWidth:kViewWidth];
    }
    return 44.f;
}

- (NSInteger)standaloneNumberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.section0List.count;
    }
    if (section == 1) {
        if (self.protocol.modem == 1) {
            return self.abpDataList.count;
        }
        if (self.protocol.modem == 2) {
            return self.otaaDataList.count;
        }
    }
    if (section == 2) {
        return self.section2List.count;
    }
    if (section == 3) {
        return self.optionsList0.count;
    }
    if (!self.protocol.advancedStatus) {
        return 0;
    }
    if (section == 4) {
        if (self.protocol.region == 1 || self.protocol.region == 2 || self.protocol.region == 8) {
            return self.optionsList1.count;
        }
        return 0;
    }
    if (section == 5) {
        if (self.protocol.region == 3 || self.protocol.region == 4
            || self.protocol.region == 5 || self.protocol.region == 9) {
            return self.optionsList2.count;
        }
        return 0;
    }
    if (section == 6) {
        return self.optionsList3.count;
    }
    if (section == 7) {
        return self.optionsList4.count;
    }
    if (section == 8 && (self.protocol.region == 0 || self.protocol.region == 1)) {
        return self.optionsList5.count;
    }
    return 0;
}

- (UITableViewCell *)standaloneCellForRowAtIndexPath:(NSIndexPath *)indexPath
                                            tableView:(UITableView *)tableView {
    if (indexPath.section == 1) {
        MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
        MKTextFieldCellModel *model = (self.protocol.modem == 1) ? self.abpDataList[indexPath.row] : self.otaaDataList[indexPath.row];
        cell.dataModel = model;
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 3) {
        MKLoRaAdvancedSettingCell *cell = [MKLoRaAdvancedSettingCell initCellWithTableView:tableView];
        cell.dataModel = self.optionsList0[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 4) {
        MKLoRaSettingCHCell *cell = [MKLoRaSettingCHCell initCellWithTableView:tableView];
        cell.dataModel = self.optionsList1[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 5 || indexPath.section == 6) {
        MKTextSwitchCell *cell = [MKTextSwitchCell initCellWithTableView:tableView];
        cell.dataModel = (indexPath.section == 5) ? self.optionsList2[indexPath.row] : self.optionsList3[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:tableView];
    if (indexPath.section == 0) {
        cell.dataModel = self.section0List[indexPath.row];
    }else if (indexPath.section == 2) {
        cell.dataModel = self.section2List[indexPath.row];
    }else if (indexPath.section == 7) {
        cell.dataModel = self.optionsList4[indexPath.row];
    }else {
        cell.dataModel = self.optionsList5[indexPath.row];
    }
    cell.delegate = self;
    return cell;
}

- (void)standaloneTextButtonCellSelected:(NSInteger)index dataListIndex:(NSInteger)dataListIndex {
    if (index == 0) {
        self.protocol.modem = (dataListIndex + 1);
        MKTextButtonCellModel *modeModel = self.section0List[0];
        modeModel.dataListIndex = dataListIndex;
        [self.tableView mk_reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
    if (index == 1) {
        self.protocol.region = dataListIndex;
        MKTextButtonCellModel *regionModel = self.section2List[0];
        regionModel.dataListIndex = dataListIndex;
        if (self.protocol.needAdvanceSetting) {
            [self standaloneRegionValueChanged];
        }
        return;
    }
    if (index == 2) {
        self.protocol.messageType = dataListIndex;
        MKTextButtonCellModel *messageModel = self.section2List[1];
        messageModel.dataListIndex = dataListIndex;
        return;
    }
    if (index == 3) {
        self.protocol.classType = dataListIndex;
        MKTextButtonCellModel *classModel = self.section2List[2];
        classModel.dataListIndex = dataListIndex;
        return;
    }
    if (index == 4) {
        self.protocol.DR = dataListIndex;
        MKTextButtonCellModel *drModel = self.optionsList4[0];
        drModel.dataListIndex = dataListIndex;
        return;
    }
    if (index == 5) {
        self.protocol.dellTime = dataListIndex;
        MKTextButtonCellModel *dellTimeModel = self.optionsList5[0];
        dellTimeModel.dataListIndex = dataListIndex;
    }
}

- (void)standaloneSwitchCellStatusChanged:(BOOL)isOn index:(NSInteger)index {
    if (index == 0) {
        self.protocol.dutyIsOn = isOn;
        MKTextSwitchCellModel *dutyModel = self.optionsList2[0];
        dutyModel.isOn = isOn;
        return;
    }
    if (index == 1) {
        self.protocol.adrIsOn = isOn;
        MKTextSwitchCellModel *adrModel = self.optionsList3[0];
        adrModel.isOn = isOn;
        MKTextButtonCellModel *drModel = self.optionsList4[0];
        drModel.buttonEnable = !isOn;
        [self.tableView mk_reloadRow:0
                           inSection:7
                    withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)standaloneRegionValueChanged {
    [self.protocol configAdvanceSettingDefaultParams];
    MKLoRaSettingCHCellModel *cellModel = self.optionsList1[0];
    cellModel.chLowValueList = [self.protocol CHLValueList];
    cellModel.chLowIndex = [self currentStandaloneCHLIndex];
    cellModel.chHighValueList = [self.protocol CHHValueList];
    cellModel.chHighIndex = [self currentStandaloneCHHIndex];

    MKTextSwitchCellModel *dutyModel = self.optionsList2[0];
    dutyModel.isOn = self.protocol.dutyIsOn;

    MKTextSwitchCellModel *adrModel = self.optionsList3[0];
    adrModel.isOn = self.protocol.adrIsOn;

    MKTextButtonCellModel *drModel = self.optionsList4[0];
    drModel.dataList = [self.protocol DRValueList];
    drModel.buttonEnable = !self.protocol.adrIsOn;
    drModel.dataListIndex = self.protocol.DR;

    MKTextButtonCellModel *dellTimeModel = self.optionsList5[0];
    dellTimeModel.dataListIndex = self.protocol.dellTime;
    [self.tableView reloadData];
}

- (NSInteger)currentStandaloneCHLIndex {
    if ([self.protocol respondsToSelector:@selector(standaloneCHLIndex)]) {
        return [self.protocol standaloneCHLIndex];
    }
    return [self getCurrentCHLIndex];
}

- (NSInteger)currentStandaloneCHHIndex {
    if ([self.protocol respondsToSelector:@selector(standaloneCHHIndex)]) {
        return [self.protocol standaloneCHHIndex];
    }
    return [self getCurrentCHHIndex];
}

- (void)loadStandaloneSectionDatas {
    [self loadSection0Datas];
    [self loadABPDatas];
    [self loadOTAADatas];
    [self loadStandaloneSection2Datas];
    if (self.protocol.needAdvanceSetting) {
        [self loadOptionsList0];
        [self loadStandaloneOptionsList1];
        [self loadOptionsList2];
        [self loadStandaloneOptionsList3];
        [self loadStandaloneOptionsList4];
        [self loadStandaloneOptionsList5];
    }
    NSInteger sections = [self standaloneSectionCount];
    for (NSInteger i = 0; i < sections; i ++) {
        MKTableSectionLineHeaderModel *headerModel = [[MKTableSectionLineHeaderModel alloc] init];
        [self.headerList addObject:headerModel];
    }
    [self.tableView reloadData];
}

- (void)loadStandaloneSection2Datas {
    MKTextButtonCellModel *regionModel = [[MKTextButtonCellModel alloc] init];
    regionModel.index = 1;
    regionModel.msg = @"Region/Subnet";
    regionModel.dataList = [self.protocol RegionList];
    regionModel.buttonLabelFont = MKFont(13.f);
    regionModel.dataListIndex = self.protocol.region;
    [self.section2List addObject:regionModel];

    if (self.protocol.supportMessageType) {
        MKTextButtonCellModel *messageModel = [[MKTextButtonCellModel alloc] init];
        messageModel.index = 2;
        messageModel.msg = @"Message Type";
        messageModel.dataList = @[@"Unconfirmed",@"Confirmed"];
        messageModel.buttonLabelFont = MKFont(13.f);
        messageModel.dataListIndex = self.protocol.messageType;
        [self.section2List addObject:messageModel];
    }

    if (self.protocol.supportClassType) {
        MKTextButtonCellModel *classModel = [[MKTextButtonCellModel alloc] init];
        classModel.index = 3;
        classModel.msg = @"Device Type";
        classModel.dataList = @[@"ClassA",@"ClassC"];
        classModel.buttonLabelFont = MKFont(13.f);
        classModel.dataListIndex = self.protocol.classType;
        [self.section2List addObject:classModel];
    }
}

- (void)loadStandaloneOptionsList1 {
    MKLoRaSettingCHCellModel *cellModel = [[MKLoRaSettingCHCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = @"CH";
    cellModel.noteMsg = @"*It is only used for US915,AU915,CN470";
    if ([self.protocol respondsToSelector:@selector(CHNoteMsg)]) {
        cellModel.noteMsg = [self.protocol CHNoteMsg];
    }
    cellModel.noteMsgColor = RGBCOLOR(102, 102, 102);
    cellModel.chLowValueList = [self.protocol CHLValueList];
    cellModel.chLowIndex = [self currentStandaloneCHLIndex];
    cellModel.chHighValueList = [self.protocol CHHValueList];
    cellModel.chHighIndex = [self currentStandaloneCHHIndex];
    [self.optionsList1 addObject:cellModel];
}

- (void)loadStandaloneOptionsList3 {
    MKTextSwitchCellModel *adrModel = [[MKTextSwitchCellModel alloc] init];
    adrModel.index = 1;
    adrModel.msg = @"ADR";
    adrModel.isOn = self.protocol.adrIsOn;
    [self.optionsList3 addObject:adrModel];
}

- (void)loadStandaloneOptionsList4 {
    MKTextButtonCellModel *drModel = [[MKTextButtonCellModel alloc] init];
    drModel.msg = @"DR";
    drModel.dataList = [self.protocol DRValueList];
    drModel.dataListIndex = self.protocol.DR;
    drModel.buttonEnable = !self.protocol.adrIsOn;
    drModel.index = 4;
    drModel.noteMsg = @"*DR only can be changed after the ADR off.";
    drModel.noteMsgColor = RGBCOLOR(102, 102, 102);
    [self.optionsList4 addObject:drModel];
}

- (void)loadStandaloneOptionsList5 {
    MKTextButtonCellModel *dellTimeModel = [[MKTextButtonCellModel alloc] init];
    dellTimeModel.msg = @"UplinkDellTime";
    dellTimeModel.dataList = @[@"0",@"1"];
    dellTimeModel.dataListIndex = self.protocol.dellTime;
    dellTimeModel.index = 5;
    dellTimeModel.noteMsg = @"*It is only used for AS923 and AU915.0: Dell Time no limit,1:Dell Time 400ms.";
    dellTimeModel.noteMsgColor = RGBCOLOR(102, 102, 102);
    [self.optionsList5 addObject:dellTimeModel];
}

#pragma mark - private method
- (void)regionValueChanged {
    if ([self isStandaloneSetting]) {
        [self standaloneRegionValueChanged];
        return;
    }
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
    //Max retransmission times
    MKTextButtonCellModel *trModel = self.optionsList8[0];
    trModel.dataListIndex = self.protocol.retransmission;
    if ([self.protocol respondsToSelector:@selector(supportEU868SingleChannel)]) {
        //EU868 Single Channel Function
        MKTextSwitchCellModel *eu868ChannelStatusModel = self.optionsList10[0];
        eu868ChannelStatusModel.isOn = self.protocol.eu868SignleChannelStatus;
        //Single Channel Selection
        MKTextButtonCellModel *eu868ChannelModel = self.optionsList11[0];
        eu868ChannelModel.dataListIndex = self.protocol.eu868SignleChannel;
    }

    [self.tableView reloadData];
}

#pragma mark - loadSections
- (void)loadSectionDatas {
    if ([self isStandaloneSetting]) {
        [self loadStandaloneSectionDatas];
        return;
    }
    [self loadLoRaDataList];
    [self loadOptionsDataList];
    //底部需要高级设置
    NSInteger advancedSections = ([self.protocol respondsToSelector:@selector(supportEU868SingleChannel)] ? 21 : 19);
    NSInteger sections = (self.protocol.advancedStatus ? advancedSections : 10);
    for (NSInteger i = 0; i < sections; i ++) {
        MKTableSectionLineHeaderModel *headerModel = [[MKTableSectionLineHeaderModel alloc] init];
        [self.headerList addObject:headerModel];
    }

    [self.tableView reloadData];
}

#pragma mark - 加载上面那个列表
- (void)loadLoRaDataList {
    [self loadSection0Datas];
    [self loadABPDatas];
    [self loadOTAADatas];
    [self loadSection1Datas];
    [self loadSection2Datas];
    [self loadSection3Datas];
    [self loadSection4Datas];
    [self loadSection5Datas];
    [self loadSection6Datas];
    [self loadSection7Datas];
}

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

- (void)loadSection1Datas {
    MKLoRaDevEUICellModel *cellModel = [[MKLoRaDevEUICellModel alloc] init];
    cellModel.devEUI = self.protocol.mokoDevEUI;
    [self.section1List addObject:cellModel];
}

/// RegionList 显示下标，默认沿用 currentRegion
- (NSInteger)regionListIndex {
    if ([self.protocol respondsToSelector:@selector(regionListIndex)]) {
        return [self.protocol regionListIndex];
    }
    return self.protocol.currentRegion;
}

- (void)loadSection2Datas {
    MKTextButtonCellModel *cellModel = [[MKTextButtonCellModel alloc] init];
    cellModel.index = 1;
    cellModel.msg = @"Region/Subnet";
    cellModel.dataList = [self.protocol RegionList];
    cellModel.buttonLabelFont = MKFont(13.f);
    cellModel.dataListIndex = [self regionListIndex];
    [self.section2List addObject:cellModel];
}

- (void)loadSection3Datas {
    MKTextButtonCellModel *cellModel = [[MKTextButtonCellModel alloc] init];
    cellModel.index = 2;
    cellModel.msg = @"Device Type";
    cellModel.dataList = @[@"Class A",@"Class C"];
    cellModel.buttonLabelFont = MKFont(13.f);
    cellModel.dataListIndex = self.protocol.classType;
    [self.section3List addObject:cellModel];
}

- (void)loadSection4Datas {
    MKTextButtonCellModel *cellModel = [[MKTextButtonCellModel alloc] init];
    cellModel.index = 3;
    cellModel.msg = @"Message Type";
    cellModel.dataList = @[@"Unconfirmed",@"Confirmed"];
    cellModel.buttonLabelFont = MKFont(13.f);
    cellModel.dataListIndex = self.protocol.messageType;
    [self.section4List addObject:cellModel];
}

- (void)loadSection5Datas {
    MKTextButtonCellModel *cellModel = [[MKTextButtonCellModel alloc] init];
    cellModel.index = 4;
    cellModel.msg = @"LoRaWAN Server Platform";
    cellModel.msgFont = MKFont(12.f);
    cellModel.dataList = @[@"Third Party NS",@"MOKO IoT DM"];
    cellModel.buttonLabelFont = MKFont(12.f);
    cellModel.dataListIndex = self.protocol.platform;
    [self.section5List addObject:cellModel];
}

- (void)loadSection6Datas {
    MKLoRaSettingAccountCellModel *cellModel = [[MKLoRaSettingAccountCellModel alloc] init];
    cellModel.account = self.protocol.account;
    [self.section6List addObject:cellModel];
}

- (void)loadSection7Datas {
    MKTextFieldCellModel *cellModel1 = [[MKTextFieldCellModel alloc] init];
    cellModel1.index = 6;
    cellModel1.msg = @"Gateway EUI(Gateway ID)";
    cellModel1.textFieldType = mk_hexCharOnly;
    cellModel1.textPlaceholder = @"8 Bytes";
    cellModel1.maxLength = 16;
    cellModel1.textFieldValue = self.protocol.gatewayEUI;
    cellModel1.noteMsg = @"*The server address, up port and down port vaule can be found in \"MOKO IoT DM Guide\" document    \n\n*Only UDP Packet forwarder protocol is available for gateway quick registration.";
    [self.section7List addObject:cellModel1];
}

#pragma mark - 加载底部列表
- (void)loadOptionsDataList {
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
    if ([self.protocol respondsToSelector:@selector(supportEU868SingleChannel)]) {
        [self loadOptionsList10];
        [self loadOptionsList11];
    }
}

- (void)loadOptionsList0 {
    MKLoRaAdvancedSettingCellModel *cellModel = [[MKLoRaAdvancedSettingCellModel alloc] init];
    cellModel.isOn = self.protocol.advancedStatus;
    [self.optionsList0 addObject:cellModel];
}

- (void)loadOptionsList1 {
    MKLoRaSettingCHCellModel *cellModel = [[MKLoRaSettingCHCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = @"CH";
    cellModel.noteMsg = @"*It is only used for US915,AU915,CN470";
    if ([self.protocol respondsToSelector:@selector(CHNoteMsg)]) {
        cellModel.noteMsg = [self.protocol CHNoteMsg];
    }
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
    dutyModel.noteMsg = @"*It is only used for EU868,CN779, EU433,and RU864. Off: The uplink report interval will not be limit by region freqency. On:The uplink report interval will be limit by region freqency.";
    if ([self.protocol respondsToSelector:@selector(dutyCycleNoteMsg)]) {
        dutyModel.noteMsg = [self.protocol dutyCycleNoteMsg];
    }
    dutyModel.noteMsgColor = RGBCOLOR(102, 102, 102);
    dutyModel.isOn = self.protocol.dutyIsOn;
    [self.optionsList2 addObject:dutyModel];
}

- (void)loadOptionsList3 {
    MKTextButtonCellModel *joinModel = [[MKTextButtonCellModel alloc] init];
    joinModel.index = 5;
    joinModel.msg = @"DR For Join";
    joinModel.dataList = [self.protocol DRValueList];
    joinModel.buttonLabelFont = MKFont(13.f);
    joinModel.dataListIndex = self.protocol.join;
    joinModel.noteMsg = @"*It is only used for CN470, CN779, EU433, EU868,KR920, IN865, RU864.";
    if ([self.protocol respondsToSelector:@selector(DRForJoinNoteMsg)]) {
        joinModel.noteMsg = [self.protocol DRForJoinNoteMsg];
    }
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
    transmissionModel.index = 6;
    transmissionModel.msg = @"Transmissions";
    transmissionModel.dataList = @[@"1",@"2"];
    transmissionModel.buttonLabelFont = MKFont(13.f);
    transmissionModel.dataListIndex = self.protocol.transmissions;
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
    retransmissionModel.index = 7;
    retransmissionModel.msg = @"Max retransmission times";
    retransmissionModel.dataList = @[@"0",@"1",@"2",@"3"];
    if ([self.protocol respondsToSelector:@selector(retransmissionValueList)]) {
        retransmissionModel.dataList = [self.protocol retransmissionValueList];
    }
    retransmissionModel.buttonLabelFont = MKFont(13.f);
    retransmissionModel.dataListIndex = self.protocol.retransmission;
    [self.optionsList8 addObject:retransmissionModel];
}

- (void)loadOptionsList9 {
    MKTextFieldCellModel *cellModel1 = [[MKTextFieldCellModel alloc] init];
    cellModel1.index = 7;
    cellModel1.msg = @"ADR_ACK_LIMIT";
    cellModel1.textFieldType = mk_realNumberOnly;
    cellModel1.textPlaceholder = @"1-255";
    if ([self.protocol respondsToSelector:@selector(ACKLimitPlaceholder)]) {
        cellModel1.textPlaceholder = [self.protocol ACKLimitPlaceholder];
    }
    cellModel1.maxLength = 3;
    cellModel1.textFieldValue = self.protocol.ackLimit;
    [self.optionsList9 addObject:cellModel1];

    MKTextFieldCellModel *cellModel2 = [[MKTextFieldCellModel alloc] init];
    cellModel2.index = 8;
    cellModel2.msg = @"ADR_ACK_DELAY";
    cellModel2.textFieldType = mk_realNumberOnly;
    cellModel2.textPlaceholder = @"1-255";
    if ([self.protocol respondsToSelector:@selector(ACKDelayPlaceholder)]) {
        cellModel2.textPlaceholder = [self.protocol ACKDelayPlaceholder];
    }
    cellModel2.maxLength = 3;
    cellModel2.textFieldValue = self.protocol.ackDelay;
    [self.optionsList9 addObject:cellModel2];
}

- (void)loadOptionsList10 {
    MKTextSwitchCellModel *cellModel = [[MKTextSwitchCellModel alloc] init];
    cellModel.index = 2;
    cellModel.msg = @"EU868 Single Channel Function";
    cellModel.isOn = self.protocol.eu868SignleChannelStatus;
    [self.optionsList10 addObject:cellModel];
}

- (void)loadOptionsList11 {
    MKTextButtonCellModel *cellModel = [[MKTextButtonCellModel alloc] init];
    cellModel.index = 8;
    cellModel.msg = @"Single Channel Selection";
    cellModel.dataList = @[@"868.1MHz",@"868.3MHz",@"868.5MHz"];
    cellModel.buttonLabelFont = MKFont(13.f);
    cellModel.dataListIndex = self.protocol.eu868SignleChannel;
    [self.optionsList11 addObject:cellModel];
}

- (NSInteger)getCurrentCHLIndex {
    NSInteger index = 0;
    for (NSInteger i = 0; i < self.protocol.CHLValueList.count; i ++) {
        if (self.protocol.CHL == [self.protocol.CHLValueList[i] integerValue]) {
            index = i;
            break;
        }
    }
    return index;
}

- (NSInteger)getCurrentCHHIndex {
    NSInteger index = 0;
    for (NSInteger i = 0; i < self.protocol.CHHValueList.count; i ++) {
        if (self.protocol.CHH == [self.protocol.CHHValueList[i] integerValue]) {
            index = i;
            break;
        }
    }
    return index;
}

- (NSInteger)getCurrentDRLIndex {
    NSInteger index = 0;
    for (NSInteger i = 0; i < self.protocol.DRLValueList.count; i ++) {
        if (self.protocol.DRL == [self.protocol.DRLValueList[i] integerValue]) {
            index = i;
            break;
        }
    }
    return index;
}

- (NSInteger)getCurrentDRHIndex {
    NSInteger index = 0;
    for (NSInteger i = 0; i < self.protocol.DRHValueList.count; i ++) {
        if (self.protocol.DRH == [self.protocol.DRHValueList[i] integerValue]) {
            index = i;
            break;
        }
    }
    return index;
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = ([self isStandaloneSetting] ? @"LoRa Setting" : @"Connection Settings");
    [self.rightButton setImage:LOADICON(@"MKLoRaCommonModule", @"MKLoRaFullSettingController", @"mk_loraModule_loraDeviceMode_slotSaveIcon.png") forState:UIControlStateNormal];
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

        if (![self isStandaloneSetting]) {
            _tableView.backgroundColor = RGBCOLOR(242, 242, 242);
        }
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

- (NSMutableArray *)section1List {
    if (!_section1List) {
        _section1List = [NSMutableArray array];
    }
    return _section1List;
}

- (NSMutableArray *)section2List {
    if (!_section2List) {
        _section2List = [NSMutableArray array];
    }
    return _section2List;
}

- (NSMutableArray *)section3List {
    if (!_section3List) {
        _section3List = [NSMutableArray array];
    }
    return _section3List;
}

- (NSMutableArray *)section4List {
    if (!_section4List) {
        _section4List = [NSMutableArray array];
    }
    return _section4List;
}

- (NSMutableArray *)section5List {
    if (!_section5List) {
        _section5List = [NSMutableArray array];
    }
    return _section5List;
}

- (NSMutableArray *)section6List {
    if (!_section6List) {
        _section6List = [NSMutableArray array];
    }
    return _section6List;
}

- (NSMutableArray *)section7List {
    if (!_section7List) {
        _section7List = [NSMutableArray array];
    }
    return _section7List;
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

- (NSMutableArray *)optionsList10 {
    if (!_optionsList10) {
        _optionsList10 = [NSMutableArray array];
    }
    return _optionsList10;
}

- (NSMutableArray *)optionsList11 {
    if (!_optionsList11) {
        _optionsList11 = [NSMutableArray array];
    }
    return _optionsList11;
}

- (NSMutableArray *)headerList {
    if (!_headerList) {
        _headerList = [NSMutableArray array];
    }
    return _headerList;
}

@end
