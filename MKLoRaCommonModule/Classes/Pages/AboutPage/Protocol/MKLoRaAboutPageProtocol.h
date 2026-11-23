//
//  MKLoRaAboutPageProtocol.h
//  MKLoRaCommonModule
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKLoRaAboutPageProtocol <NSObject>

/// 应用名称（如 "MT001"、"LW003 Plus"）
@property (nonatomic, copy) NSString *appName;

/// App 版本（如 "APP Version:1.0.6"），由各产品模块手动传入
@property (nonatomic, copy) NSString *appVersionLabel;

/// 固件版本（如 "FW Version:V1.0"、"FW Version:1.0"）
@property (nonatomic, copy) NSString *firmwareLabel;

@optional

/// App 图标，不实现时不显示图标
@property (nonatomic, strong, nullable) UIImage *aboutIcon;

/// 底部图标，不实现时不显示图标
@property (nonatomic, strong, nullable) UIImage *bottomIcon;

@end

NS_ASSUME_NONNULL_END
