//
//  MKLoRaAxisSettingPageProtocol.h
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKLoRaAxisSettingPageProtocol <NSObject>

/// Motion Wakeup Threshold
@property (nonatomic, copy) NSString *wakeupThreshold;
/// Motion Wakeup Duration
@property (nonatomic, copy) NSString *wakeupDuration;
/// Motion Threshold
@property (nonatomic, copy) NSString *motionThreshold;
/// Motion Duration
@property (nonatomic, copy) NSString *motionDuration;

/// 读取
- (void)readWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;
/// 配置
- (void)configWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@optional

/// 3-Axis Sensor Switch（仅 AJ/AK/ST 等模块有，Cellular/WB/AF/AI/DL 等没有）
@property (nonatomic, assign) BOOL isOn;

@end

NS_ASSUME_NONNULL_END
