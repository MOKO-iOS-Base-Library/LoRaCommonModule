//
//  MKLoRaPeriodicTimingPageProtocol.h
//  MKLoRaCommonModule_Example
//
//  Created by aa on 2026/11/18.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import "Models/ScanTimePoint/MKLoRaScanTimePointModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MKLoRaPeriodicTimingPageProtocol <NSObject>

@property (nonatomic, copy)NSString *duration;

@property (nonatomic, copy)NSString *interval;

@property (nonatomic, strong)NSArray <MKLoRaScanTimePointModel *>*pointList;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configData:(NSArray <MKLoRaScanTimePointModel *>*)pointList
          sucBlock:(void (^)(void))sucBlock
       failedBlock:(void (^)(NSError *error))failedBlock;

@optional
/// 业务侧同步设备时间（基础库不依赖具体 SDK）
- (void)configDeviceTimeWithRecordTime:(long long)recordTime
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError * _Nonnull error))failedBlock;

@end

NS_ASSUME_NONNULL_END
