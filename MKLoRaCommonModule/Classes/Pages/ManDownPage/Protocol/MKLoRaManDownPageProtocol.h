//
//  MKLoRaManDownPageProtocol.h
//  MKLoRaCommonModule
//
//  Created by aa on 2025/xx/xx.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKLoRaManDownPageProtocol <NSObject>

/// Man Down / Idle Detection 开关（所有模块都有，部分模块字段名 detection）
@property (nonatomic, assign) BOOL isOn;

/// Idle Detection Timeout（所有模块都有；AJ/AK/ST 叫 interval，Cellular/WB 叫 timeout，基础库统一叫 interval）
@property (nonatomic, copy) NSString *interval;

/// 读取
- (void)readWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

/// 配置
- (void)configWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

/// Reset Idle Status
- (void)resetIdleStatusWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@optional

#pragma mark - Cellular/WB 专属字段
/// 定位策略（仅 Cellular/WB 有）
@property (nonatomic, assign) NSInteger strategy;
/// 上报间隔（仅 Cellular/WB 有）
@property (nonatomic, copy, nullable) NSString *reportInterval;
/// 开始时间（仅 Cellular/WB 有）
@property (nonatomic, assign) BOOL start;
/// 结束时间（仅 Cellular/WB 有）
@property (nonatomic, assign) BOOL end;

@end

NS_ASSUME_NONNULL_END
