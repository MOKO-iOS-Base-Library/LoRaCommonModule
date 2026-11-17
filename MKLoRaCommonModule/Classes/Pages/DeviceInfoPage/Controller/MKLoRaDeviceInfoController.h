//
//  MKLoRaDeviceInfoController.h
//  MKLoRaCommonModule
//
//  Created by aa on 2025/xx/xx.
//

#import "MKBaseViewController.h"
#import "Pages/DeviceInfoPage/Protocol/MKLoRaDeviceInfoPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaDeviceInfoController : MKBaseViewController

@property (nonatomic, strong) id <MKLoRaDeviceInfoPageProtocol> protocol;

@end

NS_ASSUME_NONNULL_END
