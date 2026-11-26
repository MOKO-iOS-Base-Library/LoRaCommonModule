//
//  MKLoRaDeviceModeController.h
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/26.
//

#import "MKBaseViewController.h"
#import "Pages/DeviceModePage/Protocol/MKLoRaDeviceModePageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/// Device Mode 页：上方为设备模式选择，下方为各模式设置页入口。
@interface MKLoRaDeviceModeController : MKBaseViewController

@property (nonatomic, strong) id <MKLoRaDeviceModePageProtocol> protocol;

@end

NS_ASSUME_NONNULL_END
