//
//  MKLoRaTimingImmediatelyPageProtocol.h
//  MKLoRaCommonModule_Example
//
//  Created by aa on 2026/11/18.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import "Models/ScanTimePoint/MKLoRaScanTimePointModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MKLoRaTimingImmediatelyPageProtocol <NSObject>

@property (nonatomic, copy)NSString *duration;

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

/// 时间点分钟档位展示列表，默认00~59；仅支持00/10/20/30/40/50时返回该数组，数组下标即minuteGear
- (nullable NSArray <NSString *> *)timePointMinuteGearList;

@end

NS_ASSUME_NONNULL_END
