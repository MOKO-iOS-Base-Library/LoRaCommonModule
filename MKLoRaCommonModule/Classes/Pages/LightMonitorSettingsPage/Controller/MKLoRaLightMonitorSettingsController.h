//
//  MKLoRaLightMonitorSettingsController.h
//  MKLoRaCommonModule
//

#import "MKBaseViewController.h"
#import "Pages/LightMonitorSettingsPage/Protocol/MKLoRaLightMonitorSettingsPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaLightMonitorSettingsController : MKBaseViewController

@property (nonatomic, strong) id <MKLoRaLightMonitorSettingsPageProtocol> protocol;

@end

NS_ASSUME_NONNULL_END
