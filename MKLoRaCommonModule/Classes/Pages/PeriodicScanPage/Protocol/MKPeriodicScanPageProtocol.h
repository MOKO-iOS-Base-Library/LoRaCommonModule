//
//  MKPeriodicScanPageProtocol.h
//  MKLoRaCommonModule_Example
//
//  Created by aa on 2025/5/11.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//


NS_ASSUME_NONNULL_BEGIN

@protocol MKPeriodicScanPageProtocol <NSObject>

@property (nonatomic, copy)NSString *scanDuration;

@property (nonatomic, copy)NSString *scanInterval;

@property (nonatomic, copy)NSString *reportInterval;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
