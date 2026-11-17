//
//  MKSosAlarmSettingsController.h
//  MKLoRaCommonModule
//
//  Created by aa on 2025/xx/xx.
//

#import "MKBaseViewController.h"
#import "Pages/SosAlarmSettingsPage/Protocol/MKSosAlarmSettingsPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKSosAlarmSettingsController : MKBaseViewController

@property (nonatomic, strong) id <MKSosAlarmSettingsPageProtocol> protocol;

/// 定位策略可选项，子类可覆写（CT 等模块用 4 项版本）
- (NSArray<NSString *> *)positioningStrategyDataList;

@end

NS_ASSUME_NONNULL_END
