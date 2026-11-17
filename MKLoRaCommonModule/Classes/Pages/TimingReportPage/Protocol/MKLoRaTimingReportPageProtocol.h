//
//  MKLoRaTimingReportPageProtocol.h
//  MKLoRaCommonModule_Example
//
//  Created by aa on 2025/5/11.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import "Models/ScanTimePoint/MKLoRaScanTimePointModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MKLoRaTimingReportPageProtocol <NSObject>

@property (nonatomic, copy)NSString *duration;

@property (nonatomic, strong)NSArray <MKLoRaScanTimePointModel *>*scanPointList;

@property (nonatomic, strong)NSArray <MKLoRaScanTimePointModel *>*reportPointList;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configScanPointList:(NSArray <MKLoRaScanTimePointModel *>*)scanList
            reportPointList:(NSArray <MKLoRaScanTimePointModel *>*)reportList
                   sucBlock:(void (^)(void))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock;

@optional
/// 业务侧同步设备时间（基础库不依赖具体 SDK）
- (void)configDeviceTimeWithRecordTime:(long long)recordTime
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError * _Nonnull error))failedBlock;

@end

NS_ASSUME_NONNULL_END
