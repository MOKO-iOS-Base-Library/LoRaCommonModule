//
//  MKLoRaAlarmPayloadSettingsController.h
//  MKLoRaCommonModule
//

#import "MKBaseViewController.h"

#import "MKLoRaAlarmPayloadSettingsPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaAlarmPayloadSettingsController : MKBaseViewController

@property (nonatomic, strong)id <MKLoRaAlarmPayloadSettingsPageProtocol> protocol;

@end

NS_ASSUME_NONNULL_END
