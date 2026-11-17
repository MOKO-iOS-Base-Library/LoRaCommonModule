//
//  MKBeaconContentController.h
//  MKLoRaCommonModule
//
//  Created by aa on 2026/xx/xx.
//

#import "MKBaseViewController.h"
#import "MKBeaconContentPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKBeaconContentController : MKBaseViewController

@property (nonatomic, strong) id <MKBeaconContentPageProtocol> protocol;
@end

NS_ASSUME_NONNULL_END
