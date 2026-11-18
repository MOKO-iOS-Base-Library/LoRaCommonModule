//
//  MKLoRaUpdateController.m
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/18.
//

#import "MKLoRaUpdateController.h"

#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

#import "Masonry.h"
#import "MKBaseTableView.h"
#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"

#import "MKNormalTextCell.h"
#import "MKHudManager.h"
#import "MKCustomUIAdopter.h"

#import "MKLoRaNordicDFUModule.h"
#import "MKLoRaWapperDFUModule.h"

@interface MKLoRaUpdateController () <UITableViewDelegate, UITableViewDataSource, UIDocumentPickerDelegate>

@property (nonatomic, strong) MKBaseTableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataList;

@property (nonatomic, strong) MKLoRaNordicDFUModule *nordicDFUModule;

@property (nonatomic, strong) MKLoRaWapperDFUModule *wapperDFUModule;

@property (nonatomic, strong) dispatch_queue_t monitorQueue;

@property (nonatomic, strong) dispatch_source_t monitorSource;

@end

@implementation MKLoRaUpdateController

- (void)dealloc {
    NSLog(@"MKLoRaUpdateController销毁");
    if (self.monitorSource) {
        dispatch_cancel(self.monitorSource);
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //本页面禁止右划退出手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self loadFileList];
    [self startMonitoringDFUFiles];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MKNormalTextCellModel *firmwareModel = self.dataList[indexPath.row];
    if (!ValidStr(firmwareModel.leftMsg)) {
        [self.view showCentralToast:@"Firmware cannot be empty!"];
        return;
    }
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [document stringByAppendingPathComponent:firmwareModel.leftMsg];
    [self startDFUWithFilePath:filePath];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
    cell.dataModel = self.dataList[indexPath.row];
    return cell;
}

#pragma mark - Event method
- (void)selectBtnPressed {
    UTType *dataType = [UTType typeWithIdentifier:@"public.data"];
    UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc] initForOpeningContentTypes:@[dataType]];
    documentPicker.delegate = self;
    documentPicker.allowsMultipleSelection = NO;
    [self presentViewController:documentPicker animated:YES completion:nil];
}

#pragma mark - UIDocumentPickerDelegate
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls {
    if (urls.count == 0) {
        return;
    }
    NSURL *sourceURL = urls.firstObject;
    NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = sourceURL.lastPathComponent;
    NSString *destPath = [documentDir stringByAppendingPathComponent:fileName];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:destPath]) {
        [fileManager removeItemAtPath:destPath error:nil];
    }

    BOOL success = NO;
    if ([sourceURL startAccessingSecurityScopedResource]) {
        NSError *copyError;
        success = [fileManager copyItemAtURL:sourceURL toURL:[NSURL fileURLWithPath:destPath] error:&copyError];
        [sourceURL stopAccessingSecurityScopedResource];
    }

    if (success) {
        [self startDFUWithFilePath:destPath];
    } else {
        [self.view showCentralToast:@"Failed to import firmware file!"];
    }
}

- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller {
    //用户取消选择，无需处理
}

#pragma mark - DFU
- (void)startDFUWithFilePath:(NSString *)filePath {
    if (!ValidStr(filePath)) {
        [self.view showCentralToast:@"Firmware cannot be empty!"];
        return;
    }
    if (!self.protocol) {
        [self.view showCentralToast:@"The protocol cannot be empty!"];
        return;
    }
    //抛出该通知，设备信息页面再次返回不需要读取任何数据了，防止出现读取错误
    if ([self.protocol respondsToSelector:@selector(mk_lora_update_startDfuNotificationName)]) {
        NSString *notificationName = [self.protocol mk_lora_update_startDfuNotificationName];
        if (ValidStr(notificationName)) {
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
        }
    }
    self.leftButton.enabled = NO;
    [[MKHudManager share] showHUDWithTitle:@"Waiting..." inView:self.view isPenetration:NO];
    CBPeripheral *peripheral = [self.protocol mk_lora_update_peripheral];
    @weakify(self);
    if ([self.protocol mk_lora_update_useDFUWapper]) {
        //MKDFUWapper升级
        if ([self.protocol respondsToSelector:@selector(mk_lora_update_dfuStateChangedNotificationName)]) {
            self.wapperDFUModule.stateChangedNotificationName = [self.protocol mk_lora_update_dfuStateChangedNotificationName];
        }
        [self.wapperDFUModule updateWithPeripheral:peripheral
                                   disconnectBlock:^{
            @strongify(self);
            if ([self.protocol respondsToSelector:@selector(mk_lora_update_disconnect)]) {
                [self.protocol mk_lora_update_disconnect];
            }
        } filePath:filePath progressBlock:^(CGFloat progress) {

        } sucBlock:^{
            @strongify(self);
            [self updateSuccess];
        } failedBlock:^(NSError * _Nonnull error) {
            @strongify(self);
            [self updateFailed];
        }];
        return;
    }
    //NordicDFU升级
    [self.nordicDFUModule updateWithPeripheral:peripheral
                                      filePath:filePath
                                 progressBlock:^(CGFloat progress) {

    } sucBlock:^{
        @strongify(self);
        [self updateSuccess];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [self updateFailed];
    } centralDeallocBlock:^{
        @strongify(self);
        if ([self.protocol respondsToSelector:@selector(mk_lora_update_centralManagerDealloc)]) {
            [self.protocol mk_lora_update_centralManagerDealloc];
        }
    }];
}

- (void)updateSuccess {
    [[MKHudManager share] showHUDWithTitle:@"Update firmware successfully!" inView:self.view isPenetration:NO];
    [self performSelector:@selector(updateComplete) withObject:nil afterDelay:3.f];
}

- (void)updateFailed {
    [[MKHudManager share] showHUDWithTitle:@"Opps!DFU Failed. Please try again!" inView:self.view isPenetration:NO];
    [self performSelector:@selector(updateComplete) withObject:nil afterDelay:1.f];
}

- (void)updateComplete {
    self.leftButton.enabled = YES;
    [[MKHudManager share] hide];
    if ([self.protocol respondsToSelector:@selector(mk_lora_update_cleanUpAfterUpdate)]) {
        [self.protocol mk_lora_update_cleanUpAfterUpdate];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - 监听文件
- (void)startMonitoringDFUFiles {
    NSString *directoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSURL *directoryURL = [NSURL URLWithString:directoryPath];
    int filedes = open([[directoryURL path] fileSystemRepresentation], O_EVTONLY);
    if (filedes < 0) {
        return;
    }
    // 创建 dispatch queue, 当文件改变事件发生时会发送到该 queue
    self.monitorQueue = dispatch_queue_create("ZFileMonitorQueue", 0);

    // 创建 GCD source. 将用于监听 file descriptor 来判断是否有文件写入操作
    self.monitorSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE, filedes, DISPATCH_VNODE_WRITE, self.monitorQueue);
    // 当文件发生改变时会调用该 block
    @weakify(self);
    dispatch_source_set_event_handler(self.monitorSource, ^{
        @strongify(self);
        // 在文件发生改变时发出通知
        dispatch_async(dispatch_get_main_queue(), ^{
            //监听到有文件了
            [self loadFileList];
        });
    });

    // 当文件监听停止时会调用该 block
    dispatch_source_set_cancel_handler(self.monitorSource, ^{
        // 关闭文件监听时, 关闭该 file descriptor
        close(filedes);
    });

    // 开始监听文件
    dispatch_resume(self.monitorSource);
}

- (NSArray *)currentFileList {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    // 获取指定路径对应文件夹下的所有文件
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:document error:&error];
    return fileList;
}

- (void)loadFileList {
    NSArray *list = [self currentFileList];
    if (ValidArray(list)) {
        [self.dataList removeAllObjects];
        for (NSInteger i = 0; i < list.count; i ++) {
            MKNormalTextCellModel *model = [[MKNormalTextCellModel alloc] init];
            model.leftMsg = list[i];
            [self.dataList addObject:model];
        }
        [self.tableView reloadData];
    }
}

- (void)loadSubViews {
    self.defaultTitle = @"OTA";
    [self.rightButton setHidden:YES];
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

        _tableView.tableHeaderView = [self tableHeader];
    }
    return _tableView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (MKLoRaNordicDFUModule *)nordicDFUModule {
    if (!_nordicDFUModule) {
        _nordicDFUModule = [[MKLoRaNordicDFUModule alloc] init];
    }
    return _nordicDFUModule;
}

- (MKLoRaWapperDFUModule *)wapperDFUModule {
    if (!_wapperDFUModule) {
        _wapperDFUModule = [[MKLoRaWapperDFUModule alloc] init];
    }
    return _wapperDFUModule;
}

- (UIView *)tableHeader {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 60.f)];
    headerView.backgroundColor = COLOR_WHITE_MACROS;

    UIButton *selectBtn = [MKCustomUIAdopter customButtonWithTitle:@"Select Firmware"
                                                            target:self
                                                            action:@selector(selectBtnPressed)];
    selectBtn.frame = CGRectMake((kViewWidth - 200.f) / 2, 10.f, 200.f, 40.f);
    [headerView addSubview:selectBtn];

    return headerView;
}

@end
