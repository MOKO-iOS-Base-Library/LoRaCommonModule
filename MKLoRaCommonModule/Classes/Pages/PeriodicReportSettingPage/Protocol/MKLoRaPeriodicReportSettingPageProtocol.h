//
//  MKLoRaPeriodicReportSettingPageProtocol.h
//  MKLoRaCommonModule_Example
//
//  Created by aa on 2026/11/18.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//


NS_ASSUME_NONNULL_BEGIN

@protocol MKLoRaPeriodicReportSettingPageProtocol <NSObject>

@property (nonatomic, copy)NSString *interval;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
