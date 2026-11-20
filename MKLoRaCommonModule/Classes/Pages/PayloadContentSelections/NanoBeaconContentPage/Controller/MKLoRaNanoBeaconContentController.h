//
//  MKLoRaNanoBeaconContentController.h
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/18.
//

#import "MKBaseViewController.h"
#import "Pages/PayloadContentSelections/NanoBeaconContentPage/Protocol/MKLoRaNanoBeaconContentPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaNanoBeaconContentController : MKBaseViewController

@property (nonatomic, strong) id <MKLoRaNanoBeaconContentPageProtocol> protocol;
@end

NS_ASSUME_NONNULL_END
