//
//  MKLoRaGpsFixSettingsPageProtocol.h
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKLoRaGpsFixSettingsPageProtocol <NSObject>

/*
 0：No Report
 1：Periodic Report
 2：Timing Report
 3：Motion Report
 4：Report with BLE Payload
 */
@property (nonatomic, assign) NSInteger strategy;

/// Positioning Timeout，单位 s
@property (nonatomic, copy) NSString *timeout;

/// PDOP，单位 x0.1
@property (nonatomic, copy) NSString *pdop;

/// GPS Extreme Mode
@property (nonatomic, assign) BOOL gpsExtremeMode;

/// 读取
- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;
/// 配置
- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@optional

/// GPS Fix Strategy 选项文案，不实现默认 No Report/Periodic Report/Timing Report/Motion Report/Report with BLE Payload
- (NSArray <NSString *>*)gpsFixSettingsPageStrategyList;

/// Report Settings 子页面，顺序对应 Periodic/Timing/Motion Report Settings
- (nullable NSArray <UIViewController *> *)gpsFixSettingsPageReportViewControllers;

/// 保存按钮图标，不实现使用基础组件默认图标
- (nullable UIImage *)gpsFixSettingsPageSaveIcon;

/// 导航标题字体，不实现使用基础组件默认字体
- (nullable UIFont *)gpsFixSettingsPageNavTitleFont;

@end

NS_ASSUME_NONNULL_END
