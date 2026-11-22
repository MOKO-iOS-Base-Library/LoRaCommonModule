//
//  MKLoRaSynDataController.m
//  MKLoRaCommonModule
//
//  Created by Trae on 2026/11/22.
//

#import "MKLoRaSynDataController.h"

#import <MessageUI/MessageUI.h>

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"
#import "MKCustomUIAdopter.h"

#import "MKLoRaSynTableHeaderView.h"
#import "MKLoRaSynDataCell.h"

static NSTimeInterval const parseDataInterval = 0.1;
static NSTimeInterval const dataTimerInterval = 30.f;

static NSString *synIconAnimationKey = @"synIconAnimationKey";

@interface MKLoRaSynDataController ()<UITableViewDelegate,
UITableViewDataSource,
MFMailComposeViewControllerDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)MKLoRaSynTableHeaderView *headerView;

@property (nonatomic, strong)NSMutableArray *contentList;

/// 定时解析数据
@property (nonatomic, strong)dispatch_source_t parseTimer;

/// 返回延时定时器
@property (nonatomic, strong)dispatch_source_t backTimer;

/// 点击了返回按钮，先发送暂停命令给设备，然后2s中没有需要解析的数据了，认为可以返回了
@property (nonatomic, assign)NSInteger backCount;

/// 为65535时，最近的数据在最上面；为1时，最早的数据在最上面；
@property (nonatomic, assign)BOOL isMaxCount;

/// 当用户点击返回按钮时，如果接收到了存储数据的总条数，则需要存储总条数到本地
@property (nonatomic, copy)NSString *totalSum;

/// 定时通信，防止三分钟不同信断开连接
@property (nonatomic, strong)dispatch_source_t dataTimer;

@end

@implementation MKLoRaSynDataController

- (void)dealloc {
    NSLog(@"MKLoRaSynDataController销毁");
    if (self.dataTimer) {
        dispatch_cancel(self.dataTimer);
    }
    if (self.parseTimer) {
        dispatch_cancel(self.parseTimer);
    }
    if (self.backTimer) {
        dispatch_cancel(self.backTimer);
    }
    [self.protocol stopReceiveStorageData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
    //本页面禁止右划退出手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self readDataFromLocal];
    @weakify(self);
    [self.protocol startReceiveStorageDataWithHandler:^(NSString *content) {
        @strongify(self);
        [self receiveStorageData:content];
    }];
}

#pragma mark - super method
- (void)leftButtonMethod {
    if (![self pauseOnBack]) {
        [super leftButtonMethod];
        return;
    }
    [self.headerView.synButton.topIcon.layer removeAnimationForKey:synIconAnimationKey];
    self.headerView.synButton.msgLabel.text = @"SYNC";
    [[MKHudManager share] showHUDWithTitle:@"Waiting..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.protocol pauseSendLocalData:YES sucBlock:^{
        @strongify(self);
        [self startBackTimer];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [self startBackTimer];
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MKLoRaSynDataCell fetchCellHeight:self.dataList[indexPath.row]
                                      showMac:[self showMacAddress]
                                     showRSSI:[self showRSSI]
                               showDeviceType:[self showDeviceType]];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKLoRaSynDataCell *cell = [MKLoRaSynDataCell initCellWithTableView:tableView];
    cell.showMacAddress = [self showMacAddress];
    cell.showRSSI = [self showRSSI];
    cell.showDeviceType = [self showDeviceType];
    cell.macTitle = [self macTitle];
    cell.dataModel = self.dataList[indexPath.row];
    return cell;
}

#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result) {
        case MFMailComposeResultCancelled:  //取消
            break;
        case MFMailComposeResultSaved:      //用户保存
            break;
        case MFMailComposeResultSent:       //用户点击发送
            [self.view showCentralToast:@"send success"];
            break;
        case MFMailComposeResultFailed: //用户尝试保存或发送邮件失败
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 设备数据
- (void)receiveStorageData:(NSString *)content {
    NSDictionary *summary = [self.protocol parseSynDataSummary:content];
    NSInteger number = [summary[@"dataNumber"] integerValue];
    if (number == 0) {
        //最后一条数据
        self.totalSum = SafeStr(summary[@"totalSum"]);
        self.headerView.sumLabel.text = [NSString stringWithFormat:@"Sum:%@",self.totalSum];
        if ([self.totalSum integerValue] == 0) {
            self.headerView.countLabel.text = @"Count:0";
        }
        //开启防无通信断开连接
        [self addDataTimer];
        return;
    }
    [self.contentList addObject:content];
}

#pragma mark - event method
- (void)startButtonPressed {
    if (!ValidStr(self.headerView.textField.text)
        || [self.headerView.textField.text integerValue] < 1
        || [self.headerView.textField.text integerValue] > 65535) {
        [self.view showCentralToast:@"Time must be 1 ~ 65535"];
        return;
    }
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    @weakify(self);
    NSInteger days = [self.headerView.textField.text integerValue];
    [self.protocol readNumberOfDaysStoredData:days sucBlock:^{
        @strongify(self);
        self.isMaxCount = (days == 65535);
        NSString *daysKey = [self daysKey];
        if (ValidStr(daysKey)) {
            [[NSUserDefaults standardUserDefaults] setValue:self.headerView.textField.text forKey:daysKey];
        }
        [[MKHudManager share] hide];
        [self startButtonMethod];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)synButtonPressed {
    [self syncButtonStateUpdate];
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    [self.protocol pauseSendLocalData:!self.headerView.synButton.selected sucBlock:^{
        [[MKHudManager share] hide];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)emptyButtonPressed {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.protocol clearAllDatasWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self.dataList removeAllObjects];
        [self.contentList removeAllObjects];
        if (self.parseTimer) {
            dispatch_cancel(self.parseTimer);
        }
        self.headerView.sumLabel.text = @"Sum:0";
        self.headerView.countLabel.text = @"Count:0";
        [self.tableView reloadData];
        [self emptyButtonMethod];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)exportButtonPressed {
    if (![MFMailComposeViewController canSendMail]) {
        //如果是未绑定有效的邮箱，则跳转到系统自带的邮箱去处理
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"MESSAGE://"]
                                          options:@{}
                                completionHandler:nil];
        return;
    }
    if (!ValidArray(self.dataList)) {
        [self.view showCentralToast:@"No data to send"];
        return;
    }
    NSArray *list = [self.dataList mutableCopy];
    NSMutableData *emailData = [NSMutableData data];
    for (NSDictionary *dic in list) {
        NSString *timeString = [@"Time: " stringByAppendingString:[MKLoRaSynDataCell timeStringWithData:dic]];
        NSString *rawData = @"Raw Data: N/A";
        if (ValidStr(dic[@"rawData"])) {
            rawData = [@"Raw Data: " stringByAppendingString:dic[@"rawData"]];
        }
        NSString *stringToWrite = nil;
        if ([self exportDetail]) {
            NSString *macString = @"MAC: N/A";
            if (ValidStr(dic[@"macAddress"])) {
                macString = [@"MAC: " stringByAppendingString:dic[@"macAddress"]];
            }
            NSString *rssi = @"RSSI: N/A";
            if (ValidStr(dic[@"rssi"]) || ValidNum(dic[@"rssi"])) {
                rssi = [NSString stringWithFormat:@"RSSI: %@dBm",dic[@"rssi"]];
            }
            stringToWrite = [NSString stringWithFormat:@"\n%@\n%@\n%@\n%@",timeString,macString,rssi,rawData];
        }else {
            stringToWrite = [NSString stringWithFormat:@"\n%@\n%@",timeString,rawData];
        }
        NSData *stringData = [stringToWrite dataUsingEncoding:NSUTF8StringEncoding];
        [emailData appendData:stringData];
    }
    if (!ValidData(emailData)) {
        [self.view showCentralToast:@"Log data error"];
        return;
    }
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *bodyMsg = [NSString stringWithFormat:@"APP Version: %@ + + OS: %@",
                         version,
                         kSystemVersionString];
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    mailComposer.mailComposeDelegate = self;
    
    //收件人
    [mailComposer setToRecipients:@[@"Development@mokotechnology.com"]];
    //邮件主题
    [mailComposer setSubject:@"Feedback of mail"];
    [mailComposer addAttachmentData:emailData
                           mimeType:@"application/txt"
                           fileName:[self exportFileName]];
    [mailComposer setMessageBody:bodyMsg isHTML:NO];
    [self presentViewController:mailComposer animated:YES completion:nil];
}

#pragma mark - 数据库
- (void)readDataFromLocal {
    if (![self.protocol respondsToSelector:@selector(readLocalDataWithSucBlock:failedBlock:)]) {
        [self processStatus];
        return;
    }
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.protocol readLocalDataWithSucBlock:^(NSArray<NSDictionary *> * _Nonnull dataList) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.dataList addObjectsFromArray:dataList];
        [self processStatus];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)processStatus {
    NSString *daysKey = [self daysKey];
    if (ValidStr(daysKey)) {
        self.headerView.textField.text = [[NSUserDefaults standardUserDefaults] objectForKey:daysKey];
    }
    NSString *totalSumKey = [self totalSumKey];
    if (ValidStr(totalSumKey)) {
        self.totalSum = [[NSUserDefaults standardUserDefaults] objectForKey:totalSumKey];
    }
    if (ValidStr(self.totalSum)) {
        self.headerView.sumLabel.text = [NSString stringWithFormat:@"Sum:%@",self.totalSum];
    }else {
        self.headerView.sumLabel.text = @"Sum:N/A";
    }
    
    if (self.dataList.count > 0) {
        self.headerView.countLabel.text = [NSString stringWithFormat:@"Count:%ld",(long)self.dataList.count];
        [self refreshStartButton:YES];
        [self refreshSynButton:YES];
        [self refreshEmptyButton:YES];
        [self refreshExportButton:YES];
    }else {
        //本地没有存储数据，则start、empty、sync不可用
        self.headerView.countLabel.text = @"Count:N/A";
        [self refreshStartButton:YES];
        [self refreshSynButton:NO];
        [self refreshEmptyButton:NO];
        [self refreshExportButton:NO];
    }
    
    [self.tableView reloadData];
}

#pragma mark - 按钮刷新UI事件
- (void)startButtonMethod {
    //用户发送给设备开始读取数据了
    //清除数据库数据和数据列表数据
    if (self.parseTimer) {
        dispatch_cancel(self.parseTimer);
    }
    [self.dataList removeAllObjects];
    [self.contentList removeAllObjects];
    [self.tableView reloadData];
    
    //start按钮置灰、empty、export都不可用
    [self refreshStartButton:NO];
    
    self.headerView.emptyButton.enabled = NO;
    [self refreshEmptyButton:NO];
    
    [self refreshExportButton:NO];
    
    //sync按钮可用，选中状态，开启动画
    [self refreshSynButton:YES];
    self.headerView.synButton.selected = YES;
    [self.headerView.synButton.topIcon.layer removeAnimationForKey:synIconAnimationKey];
    //开始旋转
    [self.headerView.synButton.topIcon.layer addAnimation:[MKCustomUIAdopter refreshAnimation:2.f] forKey:synIconAnimationKey];
    self.headerView.synButton.msgLabel.text = @"STOP";
    self.headerView.sumLabel.text = @"Sum:N/A";
    self.totalSum = @"";
    [self addTimerForRefresh];
}

- (void)syncButtonStateUpdate {
    self.headerView.synButton.selected = !self.headerView.synButton.selected;
    [self.headerView.synButton.topIcon.layer removeAnimationForKey:synIconAnimationKey];
    if (self.headerView.synButton.selected) {
        //如果监听数据，start按钮置灰、empty、export都不可用
        [self refreshEmptyButton:NO];
        [self refreshExportButton:NO];
        
        //开始旋转
        [self.headerView.synButton.topIcon.layer addAnimation:[MKCustomUIAdopter refreshAnimation:2.f] forKey:synIconAnimationKey];
        self.headerView.synButton.msgLabel.text = @"STOP";
        self.totalSum = @"";
        [self addTimerForRefresh];
    }else {
        //停止监听数据，start按钮恢复正常状态,本地如果有数据,empty、export都可用，如果没有则empty、export都不可用
        [self refreshStartButton:YES];
        
        BOOL enable = (self.dataList.count > 0);
        [self refreshEmptyButton:enable];
        [self refreshExportButton:enable];
        
        self.headerView.synButton.msgLabel.text = @"SYNC";
        if (self.parseTimer) {
            dispatch_cancel(self.parseTimer);
            self.parseTimer = nil;
        }
    }
}

- (void)emptyButtonMethod {
    [self refreshStartButton:YES];
    
    [self refreshSynButton:NO];
    
    [self refreshEmptyButton:YES];
    
    [self refreshExportButton:YES];
}

- (void)startBackTimer {
    self.backTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(self.backTimer, dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC),  0.5 * NSEC_PER_SEC, 0);
    @weakify(self);
    dispatch_source_set_event_handler(self.backTimer, ^{
        @strongify(self);
        self.backCount ++;
        if (self.backCount == 4) {
            //数据全部解析完成,把所有数据缓存到本地
            moko_dispatch_main_safe(^{
                dispatch_cancel(self.backTimer);
                [self saveDataToLocal];
            });
            return;
        }
    });
    dispatch_resume(self.backTimer);
}

- (void)saveDataToLocal {
    if ([self.protocol respondsToSelector:@selector(clearLocalData)]) {
        [self.protocol clearLocalData];
    }
    NSString *totalSumKey = [self totalSumKey];
    if (ValidStr(totalSumKey)) {
        [[NSUserDefaults standardUserDefaults] setValue:SafeStr(self.totalSum) forKey:totalSumKey];
    }
    if (self.dataList.count == 0
        || ![self.protocol respondsToSelector:@selector(saveLocalDataList:sucBlock:failedBlock:)]) {
        [[MKHudManager share] hide];
        [super leftButtonMethod];
        return;
    }
    @weakify(self);
    [self.protocol saveLocalDataList:self.dataList sucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [super leftButtonMethod];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - 维持通信
- (void)addDataTimer {
    self.dataTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(self.dataTimer, dispatch_walltime(NULL, 0),  dataTimerInterval * NSEC_PER_SEC, 0);
    @weakify(self);
    dispatch_source_set_event_handler(self.dataTimer, ^{
        @strongify(self);
        moko_dispatch_main_safe(^{
            [self.protocol keepAlive];
        });
    });
    dispatch_resume(self.dataTimer);
}

#pragma mark - 刷新
- (void)addTimerForRefresh {
    self.parseTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(self.parseTimer, dispatch_time(DISPATCH_TIME_NOW, parseDataInterval * NSEC_PER_SEC),  parseDataInterval * NSEC_PER_SEC, 0);
    @weakify(self);
    dispatch_source_set_event_handler(self.parseTimer, ^{
        @strongify(self);
        moko_dispatch_main_safe(^{
            [self parseContentDatas];
        });
    });
    dispatch_resume(self.parseTimer);
}

- (void)parseContentDatas {
    if (self.contentList.count == 0) {
        NSInteger tempNumber = self.dataList.count;
        if (ValidStr(self.totalSum) && [self.totalSum integerValue] == tempNumber) {
            //解析完成
            if (self.parseTimer) {
                dispatch_cancel(self.parseTimer);
            }
        }
        self.headerView.countLabel.text = [NSString stringWithFormat:@"Count:%ld",(long)tempNumber];
        return;
    }
    NSString *firstContent = self.contentList[0];
    NSArray *tempList = [self.protocol parseSynDataContent:firstContent];
    [self.contentList removeObjectAtIndex:0];
    //业务需求最近的数据在最上面
    if (self.isMaxCount && self.dataList.count > 0) {
        for (NSDictionary *dic in tempList) {
            [self.dataList insertObject:dic atIndex:0];
        }
    }else {
        [self.dataList addObjectsFromArray:tempList];
    }
    NSInteger number = self.dataList.count;
    if (ValidStr(self.totalSum) && [self.totalSum integerValue] < number) {
        number = [self.totalSum integerValue];
    }
    self.headerView.countLabel.text = [NSString stringWithFormat:@"Count:%ld",(long)number];
    [self.tableView reloadData];
}

#pragma mark - 按钮状态
- (void)refreshStartButton:(BOOL)enable {
    self.headerView.startButton.enabled = enable;
    [self.headerView.startButton setBackgroundColor:(enable ? NAVBAR_COLOR_MACROS : [UIColor grayColor])];
    [self.headerView.startButton setTitleColor:(enable ? COLOR_WHITE_MACROS : DEFAULT_TEXT_COLOR) forState:UIControlStateNormal];
}

- (void)refreshSynButton:(BOOL)enable {
    self.headerView.synButton.enabled = enable;
    self.headerView.synButton.topIcon.image = [self iconWithType:(enable ? MKLoRaSynDataPageIconTypeSyncEnable : MKLoRaSynDataPageIconTypeSyncDisable)];
    [self.headerView.synButton setNeedsLayout];
}

- (void)refreshEmptyButton:(BOOL)enable {
    self.headerView.emptyButton.enabled = enable;
    self.headerView.emptyButton.topIcon.image = [self iconWithType:(enable ? MKLoRaSynDataPageIconTypeDeleteEnable : MKLoRaSynDataPageIconTypeDeleteDisable)];
    [self.headerView.emptyButton setNeedsLayout];
}

- (void)refreshExportButton:(BOOL)enable {
    self.headerView.exportButton.enabled = enable;
    self.headerView.exportButton.topIcon.image = [self iconWithType:(enable ? MKLoRaSynDataPageIconTypeExportEnable : MKLoRaSynDataPageIconTypeExportDisable)];
    [self.headerView.exportButton setNeedsLayout];
}

#pragma mark - 页面配置
- (NSString *)pageTitle {
    if ([self.protocol respondsToSelector:@selector(synDataPageTitle)]) {
        NSString *title = self.protocol.synDataPageTitle;
        if (ValidStr(title)) {
            return title;
        }
    }
    return @"Local Data Sync";
}

- (NSString *)exportFileName {
    if ([self.protocol respondsToSelector:@selector(synDataPageExportFileName)]) {
        NSString *fileName = self.protocol.synDataPageExportFileName;
        if (ValidStr(fileName)) {
            return fileName;
        }
    }
    return @"LoRaWAN Data.txt";
}

- (NSString *)daysKey {
    if ([self.protocol respondsToSelector:@selector(synDataPageDaysKey)]) {
        return self.protocol.synDataPageDaysKey;
    }
    return nil;
}

- (NSString *)totalSumKey {
    if ([self.protocol respondsToSelector:@selector(synDataPageTotalSumKey)]) {
        return self.protocol.synDataPageTotalSumKey;
    }
    return nil;
}

- (BOOL)showMacAddress {
    if ([self.protocol respondsToSelector:@selector(synDataPageShowMacAddress)]) {
        return self.protocol.synDataPageShowMacAddress;
    }
    return NO;
}

- (BOOL)showRSSI {
    if ([self.protocol respondsToSelector:@selector(synDataPageShowRSSI)]) {
        return self.protocol.synDataPageShowRSSI;
    }
    return NO;
}

- (BOOL)showDeviceType {
    if ([self.protocol respondsToSelector:@selector(synDataPageShowDeviceType)]) {
        return self.protocol.synDataPageShowDeviceType;
    }
    return NO;
}

- (BOOL)exportDetail {
    if ([self.protocol respondsToSelector:@selector(synDataPageExportDetail)]) {
        return self.protocol.synDataPageExportDetail;
    }
    return NO;
}

- (BOOL)pauseOnBack {
    if ([self.protocol respondsToSelector:@selector(synDataPagePauseOnBack)]) {
        return self.protocol.synDataPagePauseOnBack;
    }
    return YES;
}

- (NSString *)macTitle {
    if ([self.protocol respondsToSelector:@selector(synDataPageMacTitle)]) {
        NSString *title = self.protocol.synDataPageMacTitle;
        if (ValidStr(title)) {
            return title;
        }
    }
    return @"MAC Address:";
}

- (UIImage *)iconWithType:(MKLoRaSynDataPageIconType)type {
    if ([self.protocol respondsToSelector:@selector(synDataPageIcon:)]) {
        return [self.protocol synDataPageIcon:type];
    }
    return nil;
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = [self pageTitle];
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
        _tableView.backgroundColor = COLOR_WHITE_MACROS;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableHeaderView = self.headerView;
    }
    return _tableView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (NSMutableArray *)contentList {
    if (!_contentList) {
        _contentList = [NSMutableArray array];
    }
    return _contentList;
}

- (MKLoRaSynTableHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[MKLoRaSynTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 100.f)];
        [_headerView.startButton addTarget:self
                                    action:@selector(startButtonPressed)
                          forControlEvents:UIControlEventTouchUpInside];
        [_headerView.synButton addTarget:self
                                  action:@selector(synButtonPressed)
                        forControlEvents:UIControlEventTouchUpInside];
        [_headerView.emptyButton addTarget:self
                                    action:@selector(emptyButtonPressed)
                          forControlEvents:UIControlEventTouchUpInside];
        [_headerView.exportButton addTarget:self
                                     action:@selector(exportButtonPressed)
                           forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerView;
}

@end
