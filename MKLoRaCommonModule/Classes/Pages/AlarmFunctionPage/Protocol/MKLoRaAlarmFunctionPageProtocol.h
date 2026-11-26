//
//  MKLoRaAlarmFunctionPageProtocol.h
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/18.
//

#import <UIKit/UIKit.h>
#import "Pages/AlertAlarmSettingsPage/Protocol/MKLoRaAlertAlarmSettingsPageProtocol.h"
#import "Pages/SosAlarmSettingsPage/Protocol/MKLoRaSosAlarmSettingsPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MKLoRaAlarmFunctionPageProtocol <NSObject>

/// 0:No  1:Alert  2:SOS
@property (nonatomic, assign)NSInteger alarmType;

@property (nonatomic, copy)NSString *exitTime;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@optional

/// Alert Alarm Settings 子页的数据源，不实现时子页无数据
@property (nonatomic, strong, nullable) id <MKLoRaAlertAlarmSettingsPageProtocol> alertAlarmSettingsProtocol;

/// SOS Alarm Settings 子页的数据源，不实现时子页无数据
@property (nonatomic, strong, nullable) id <MKLoRaSosAlarmSettingsPageProtocol> sosAlarmSettingsProtocol;

@end

NS_ASSUME_NONNULL_END
