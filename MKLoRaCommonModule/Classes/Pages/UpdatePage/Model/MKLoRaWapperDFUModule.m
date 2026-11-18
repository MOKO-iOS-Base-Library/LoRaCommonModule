//
//  MKLoRaWapperDFUModule.m
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/18.
//

#import "MKLoRaWapperDFUModule.h"

#import "MKMacroDefines.h"

@import MKDFUWapper;

static NSString *const dfuUpdateDomain = @"com.moko.dfuUpdateDomain";

@interface MKLoRaWapperDFUModule () <MKDFUWrapperDelegate>

@property (nonatomic, copy) void (^progressBlock)(CGFloat progress);
@property (nonatomic, copy) void (^updateSucBlock)(void);
@property (nonatomic, copy) void (^updateFailedBlock)(NSError *error);

@property (nonatomic, strong) MKDFUWrapper *dfuWrapper;
@property (nonatomic, assign) BOOL isUpdating;

@end

@implementation MKLoRaWapperDFUModule

- (instancetype)init {
    if (self = [super init]) {
        _isUpdating = NO;
        _dfuWrapper = [[MKDFUWrapper alloc] init];
        _dfuWrapper.delegate = self;
    }
    return self;
}

- (void)dealloc {
    [self cancelUpdate];
    NSLog(@"MKLoRaWapperDFUModule销毁");
}

#pragma mark - Public Methods

- (void)updateWithPeripheral:(CBPeripheral *)peripheral
             disconnectBlock:(void (^)(void))disconnectBlock
                    filePath:(NSString *)filePath
               progressBlock:(void (^)(CGFloat progress))progressBlock
                    sucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock {
    if (self.isUpdating) {
        [self operationFailedBlock:failedBlock msg:@"DFU is already in progress"];
        return;
    }
    if (!ValidStr(filePath)) {
        [self operationFailedBlock:failedBlock msg:@"The url is invalid!"];
        return;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath]) {
        [self operationFailedBlock:failedBlock msg:@"Firmware file not found!"];
        return;
    }
    NSData *firmwareData = [NSData dataWithContentsOfFile:filePath];
    if (!ValidData(firmwareData)) {
        [self operationFailedBlock:failedBlock msg:@"Failed to read firmware file!"];
        return;
    }

    self.progressBlock = progressBlock;
    self.updateSucBlock = sucBlock;
    self.updateFailedBlock = failedBlock;
    self.isUpdating = YES;
    [self postStateChangedNotification:YES];

    if (!peripheral) {
        [self postStateChangedNotification:NO];
        [self operationFailedBlock:failedBlock msg:@"Device not connected!"];
        self.isUpdating = NO;
        return;
    }

    NSLog(@"========================================");
    NSLog(@"DFU: Starting firmware upgrade");
    NSLog(@"DFU: Device: %@", peripheral.name ?: @"Unknown");
    NSLog(@"DFU: Firmware size: %.2f KB", firmwareData.length / 1024.0);
    NSLog(@"========================================");

    // 先断开App的BLE连接，让DFU Transport通过自己的CBCentralManager管理连接。
    // 这样设备在DFU过程中断开后，Transport能收到断开回调并自动重连。
    NSLog(@"DFU: Disconnecting app BLE connection...");
    if (disconnectBlock) {
        disconnectBlock();
    }

    // 等待2秒确保App的BLE连接完全断开，再启动DFU
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf) sself = weakSelf;
        if (!sself || !sself.isUpdating) {
            return;
        }
        NSLog(@"DFU: App BLE disconnected. Starting DFU with transport-owned connection...");
        [sself.dfuWrapper startDFUWith:peripheral
                          firmwareData:firmwareData
                           upgradeMode:MKDFUUpgradeModeTestAndConfirm];
    });
}

- (void)cancelUpdate {
    [self.dfuWrapper cancelDFU];
    self.isUpdating = NO;
}

#pragma mark - MKDFUWrapperDelegate

- (void)dfuProgressDidChange:(float)progress {
    NSLog(@"DFU Progress: %.1f%%", progress * 100);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.progressBlock) {
            self.progressBlock(progress);
        }
    });
}

- (void)dfuStateDidChange:(NSString *)state {
    NSLog(@"DFU State: %@", state);
}

- (void)dfuDidComplete {
    NSLog(@"========================================");
    NSLog(@"DFU: Upgrade completed successfully!");
    NSLog(@"========================================");

    self.isUpdating = NO;
    [self postStateChangedNotification:NO];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.updateSucBlock) {
            self.updateSucBlock();
        }
    });
}

- (void)dfuDidFailWithError:(NSString *)error {
    NSLog(@"========================================");
    NSLog(@"DFU: Upgrade failed");
    NSLog(@"DFU: Error: %@", error);
    NSLog(@"========================================");

    self.isUpdating = NO;
    [self postStateChangedNotification:NO];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self operationFailedBlock:self.updateFailedBlock msg:error];
    });
}

- (void)dfuDidCancel {
    NSLog(@"DFU: Upgrade cancelled");
    self.isUpdating = NO;
    [self postStateChangedNotification:NO];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.updateFailedBlock) {
            NSError *error = [[NSError alloc] initWithDomain:dfuUpdateDomain
                                                        code:-999
                                                    userInfo:@{@"errorInfo": @"DFU cancelled"}];
            self.updateFailedBlock(error);
        }
    });
}

#pragma mark - Private Methods

- (void)postStateChangedNotification:(BOOL)isUpdating {
    if (!ValidStr(self.stateChangedNotificationName)) {
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:self.stateChangedNotificationName
                                                        object:nil
                                                      userInfo:@{@"isUpdating": @(isUpdating)}];
}

- (void)operationFailedBlock:(void (^)(NSError *error))failedBlock msg:(NSString *)msg {
    self.isUpdating = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (failedBlock) {
            NSError *error = [[NSError alloc] initWithDomain:dfuUpdateDomain
                                                        code:-999
                                                    userInfo:@{@"errorInfo": SafeStr(msg)}];
            failedBlock(error);
        }
    });
}

@end
