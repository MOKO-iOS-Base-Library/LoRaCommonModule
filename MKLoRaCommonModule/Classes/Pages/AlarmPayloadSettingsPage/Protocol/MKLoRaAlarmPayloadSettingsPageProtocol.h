//
//  MKLoRaAlarmPayloadSettingsPageProtocol.h
//  MKLoRaCommonModule
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKLoRaAlarmPayloadSettingsPageProtocol <NSObject>

@property (nonatomic, assign)BOOL isOn;

/// Duplicate Alarm Data Filter 0:No  1:MAC   2:MAC+Data Type 3:MAC+Raw Data
@property (nonatomic, assign)NSInteger filter;

@property (nonatomic, copy)NSString *period;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@optional
/// 保存按钮图标，不实现使用基础组件默认图标
- (nullable UIImage *)alarmPayloadSettingsPageSaveIcon;

/// 导航标题字体，不实现使用基础组件默认字体
- (nullable UIFont *)alarmPayloadSettingsPageNavTitleFont;

@end

NS_ASSUME_NONNULL_END
