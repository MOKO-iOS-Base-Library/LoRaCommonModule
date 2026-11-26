//
//  MKLoRaBleSettingsPageProtocol.h
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/18.
//

#import <UIKit/UIKit.h>

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

/// ADV Name 最大输入长度，不实现默认 16（AF/AI 为 20）
@property (nonatomic, assign) NSInteger bleSettingsPageAdvNameMaxLength;

/// Beacon Mode 开启时是否仍显示 Broadcast Timeout，不实现默认 NO（Beacon Mode 下隐藏）
@property (nonatomic, assign) BOOL bleSettingsPageAlwaysShowBroadcastTimeout;

/// 页面标题，不实现默认 Bluetooth Settings
- (nullable NSString *)bleSettingsPageTitle;

/// 保存按钮图标，不实现使用基础组件默认图标
- (nullable UIImage *)bleSettingsPageSaveIcon;

/// 导航标题字体，不实现使用基础组件默认字体
- (nullable UIFont *)bleSettingsPageNavTitleFont;

/// ADV Interval 最大输入长度，不实现默认 3
@property (nonatomic, assign) NSInteger bleSettingsPageAdvIntervalMaxLength;

/// ADV Interval 提示文案，不实现默认 1 ~ 100
- (nullable NSString *)bleSettingsPageAdvIntervalPlaceholder;

/// Tx Power 行高，不实现默认 95.f（9/14 档位模块原设计 85.f，28 档位密集模块 95.f）
- (CGFloat)bleSettingsPageTxPowerRowHeight;

/// Tx Power 行括号内说明文字，不实现由基础库根据 bleSettingsPageTxPowerValues 动态生成（正数前自动补 "+"）
/// AJ/AK/ST 等密集档位模块原设计正数前不带 "+"，需实现此方法返回完整字符串
- (nullable NSString *)bleSettingsPageTxPowerNoteText;

/// 页面底部额外间距，用于避开 TabBar，不实现默认 0（内容到安全区为止）
- (CGFloat)bleSettingsPageBottomInset;

/// 是否隐藏 Beacon Mode 分组（模块不支持 Beacon Mode 时返回 YES），不实现默认 NO
@property (nonatomic, assign) BOOL bleSettingsPageHideBeaconMode;

@end

NS_ASSUME_NONNULL_END
