//
//  MKLoRaNordicDFUModule.m
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/18.
//

#import "MKLoRaNordicDFUModule.h"

#import "MKMacroDefines.h"

@import NordicDFU;

static NSString *const dfuUpdateDomain = @"com.moko.dfuUpdateDomain";

@interface MKLoRaNordicDFUModule () <LoggerDelegate, DFUServiceDelegate, DFUProgressDelegate>

@property (nonatomic, copy)void (^progressBlock)(CGFloat progress);

@property (nonatomic, copy)void (^updateSucBlock)(void);

@property (nonatomic, copy)void (^updateFailedBlock)(NSError *error);

@property (nonatomic, copy)void (^centralDeallocBlock)(void);

@property (nonatomic, strong)DFUServiceController *dfuController;

@end

@implementation MKLoRaNordicDFUModule

- (void)dealloc {
    NSLog(@"MKLoRaNordicDFUModule销毁");
}

- (void)updateWithPeripheral:(CBPeripheral *)peripheral
                    filePath:(NSString *)filePath
               progressBlock:(void (^)(CGFloat progress))progressBlock
                    sucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock
         centralDeallocBlock:(void (^)(void))centralDeallocBlock {
    if (!ValidStr(filePath)) {
        [self operationFailedBlock:failedBlock msg:@"The url is invalid!"];
        return;
    }
    NSData *zipData = [NSData dataWithContentsOfFile:filePath];
    if (!ValidData(zipData)) {
        [self operationFailedBlock:failedBlock msg:@"Dfu upgrade failure!"];
        return;
    }
    NSError *firmwareError = nil;
    DFUFirmware *selectedFirmware = [[DFUFirmware alloc] initWithZipFile:zipData error:&firmwareError];
    if (!selectedFirmware) {
        [self operationFailedBlock:failedBlock msg:@"Dfu upgrade failure!"];
        return;
    }
    DFUServiceInitiator *initiator = [[DFUServiceInitiator alloc] initWithQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                                                                 delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                                                                progressQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                                                                  loggerQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                                                        centralManagerOptions:@{}];
    initiator = [initiator withFirmware:selectedFirmware];
    initiator.logger = self;
    initiator.delegate = self;
    initiator.progressDelegate = self;

    self.progressBlock = progressBlock;
    self.updateSucBlock = sucBlock;
    self.updateFailedBlock = failedBlock;
    self.centralDeallocBlock = centralDeallocBlock;

    self.dfuController = [initiator startWithTarget:peripheral];
}

#pragma mark - DFUServiceDelegate

- (void)dfuStateDidChangeTo:(enum DFUState)state {
    if (state == DFUStateCompleted) {
        moko_dispatch_main_safe(^{
            if (self.updateSucBlock) {
                self.updateSucBlock();
            }
        });
    }
    if (state == DFUStateUploading && self.centralDeallocBlock) {
        self.centralDeallocBlock();
    }
}

- (void)dfuError:(enum DFUError)error didOccurWithMessage:(NSString *)message {
    [self operationFailedBlock:self.updateFailedBlock msg:message];
}

#pragma mark - DFUProgressDelegate

- (void)dfuProgressDidChangeFor:(NSInteger)part
                         outOf:(NSInteger)totalParts
                            to:(NSInteger)progress
        currentSpeedBytesPerSecond:(double)currentSpeedBytesPerSecond
           avgSpeedBytesPerSecond:(double)avgSpeedBytesPerSecond {
    float currentProgress = (float)progress / totalParts;
    moko_dispatch_main_safe(^{
        if (self.progressBlock) {
            self.progressBlock(currentProgress);
        }
    });
}

#pragma mark - LoggerDelegate

- (void)logWith:(enum LogLevel)level message:(NSString *)message {
    NSLog(@"%logWith ld: %@", (long)level, message);
}

#pragma mark - Private method

- (void)operationFailedBlock:(void (^)(NSError *error))failedBlock msg:(NSString *)msg {
    moko_dispatch_main_safe(^{
        if (failedBlock) {
            NSError *error = [[NSError alloc] initWithDomain:dfuUpdateDomain
                                                        code:-999
                                                    userInfo:@{@"errorInfo":SafeStr(msg)}];
            failedBlock(error);
        }
    });
}

@end
