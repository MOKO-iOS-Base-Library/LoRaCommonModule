//
//  MKLoRaBleSettingsController.h
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/18.
//

#import "MKBaseViewController.h"
#import "Pages/BleSettingsPage/Protocol/MKLoRaBleSettingsPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaBleSettingsController : MKBaseViewController

@property (nonatomic, strong) id <MKLoRaBleSettingsPageProtocol> protocol;

@end

NS_ASSUME_NONNULL_END
