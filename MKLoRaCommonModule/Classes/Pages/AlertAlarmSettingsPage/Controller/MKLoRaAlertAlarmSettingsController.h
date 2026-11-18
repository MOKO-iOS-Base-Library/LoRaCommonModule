//
//  MKLoRaAlertAlarmSettingsController.h
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/18.
//

#import "MKBaseViewController.h"
#import "Pages/AlertAlarmSettingsPage/Protocol/MKLoRaAlertAlarmSettingsPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaAlertAlarmSettingsController : MKBaseViewController

@property (nonatomic, strong) id <MKLoRaAlertAlarmSettingsPageProtocol> protocol;

/// 定位策略可选项，子类可覆写（CT 等模块用 4 项版本）
- (NSArray<NSString *> *)positioningStrategyDataList;

@end

NS_ASSUME_NONNULL_END
