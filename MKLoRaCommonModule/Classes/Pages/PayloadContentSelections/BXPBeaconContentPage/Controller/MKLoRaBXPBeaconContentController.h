//
//  MKLoRaBXPBeaconContentController.h
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/18.
//

#import "MKBaseViewController.h"
#import "Pages/PayloadContentSelections/BXPBeaconContentPage/Protocol/MKLoRaBXPBeaconContentPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaBXPBeaconContentController : MKBaseViewController

@property (nonatomic, strong) id <MKLoRaBXPBeaconContentPageProtocol> protocol;
@end

NS_ASSUME_NONNULL_END
