//
//  MKLoRaAlarmFunctionController.h
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/18.
//

#import "MKBaseViewController.h"
#import "Pages/AlarmFunctionPage/Protocol/MKLoRaAlarmFunctionPageProtocol.h"
#import "Pages/AlertAlarmSettingsPage/Controller/MKLoRaAlertAlarmSettingsController.h"
#import "Pages/SosAlarmSettingsPage/Controller/MKLoRaSosAlarmSettingsController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaAlarmFunctionController : MKBaseViewController

@property (nonatomic, strong) id <MKLoRaAlarmFunctionPageProtocol> protocol;

/// Alert Alarm Settings 子页，子类可覆写以替换为产品自己的实现
- (MKLoRaAlertAlarmSettingsController *)alertAlarmSettingsController;

/// SOS Alarm Settings 子页，子类可覆写以替换为产品自己的实现
- (MKLoRaSosAlarmSettingsController *)sosAlarmSettingsController;

@end

NS_ASSUME_NONNULL_END
