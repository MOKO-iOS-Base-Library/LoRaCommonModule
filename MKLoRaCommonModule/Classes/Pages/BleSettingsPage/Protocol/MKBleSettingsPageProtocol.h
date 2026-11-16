//
//  MKBleSettingsPageProtocol.h
//  MKLoRaCommonModule
//
//  Created by aa on 2025/xx/xx.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKBleSettingsPageProtocol <NSObject>

/// ADV Name
@property (nonatomic, copy) NSString *advName;
/// Tx Power 数值索引（各模块档位不同，基础库只存数值）
@property (nonatomic, assign) NSInteger txPower;
/// ADV Interval
@property (nonatomic, copy) NSString *interval;
/// Beacon Mode（仅 AJ/ST 等 6 字段档模块有）
@property (nonatomic, assign) BOOL beaconMode;
/// Broadcast Timeout
@property (nonatomic, copy) NSString *timeout;
/// Login Password 开关
@property (nonatomic, assign) BOOL needPassword;

/// 读取
- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;
/// 配置
- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@optional

/// 是否通过密码登录（决定 Change Password 入口是否可点击）
@property (nonatomic, assign) BOOL hasLoginPassword;

/// Change Password 入口点击（业务侧处理 alert + SDK 调用）
- (void)bleSettingsPageDidSelectChangePassword;

/// 业务自定义 Tx Power cell 时返回 YES
- (BOOL)bleSettingsPageShouldUseCustomTxPowerCell;

/// txPower 数值索引转 dBm 显示文本
- (NSString *)bleSettingsPage_txPowerDisplayString;

@end

NS_ASSUME_NONNULL_END
