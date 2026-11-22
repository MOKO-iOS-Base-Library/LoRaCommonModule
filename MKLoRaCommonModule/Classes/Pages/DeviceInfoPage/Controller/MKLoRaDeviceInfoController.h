//
//  MKLoRaDeviceInfoController.h
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/18.
//

#import "MKBaseViewController.h"
#import "Pages/DeviceInfoPage/Protocol/MKLoRaDeviceInfoPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaDeviceInfoController : MKBaseViewController

@property (nonatomic, strong) id <MKLoRaDeviceInfoPageProtocol> protocol;

/// 是否隐藏 Battery Consumption Information 入口，默认 NO。
/// 不支持电量消耗统计的产品在子类中置 YES。
@property (nonatomic, assign) BOOL hideBatteryConsumption;

@end

NS_ASSUME_NONNULL_END
