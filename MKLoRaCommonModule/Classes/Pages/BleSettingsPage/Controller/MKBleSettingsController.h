//
//  MKBleSettingsController.h
//  MKLoRaCommonModule
//
//  Created by aa on 2025/xx/xx.
//

#import "MKBaseViewController.h"
#import "MKBleSettingsPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKBleSettingsController : MKBaseViewController

@property (nonatomic, strong) id <MKBleSettingsPageProtocol> protocol;

@end

NS_ASSUME_NONNULL_END
