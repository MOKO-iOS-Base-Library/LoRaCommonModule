//
//  MKLoRaTHSettingsController.h
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/23.
//

#import "MKBaseViewController.h"
#import "Pages/THSettingsPage/Protocol/MKLoRaTHSettingsPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaTHSettingsController : MKBaseViewController

@property (nonatomic, strong) id <MKLoRaTHSettingsPageProtocol> protocol;

@end

NS_ASSUME_NONNULL_END
