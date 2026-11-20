//
//  MKLoRaBleSettingsPageProtocol.h
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKLoRaBleSettingsPageProtocol <NSObject>

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

/// 各档位Tx Power的dBm文案，顺序与设备数值索引一致（各产品档位不同，必须由业务传入）
- (NSArray <NSString *>*)bleSettingsPageTxPowerValues;

@end

NS_ASSUME_NONNULL_END
