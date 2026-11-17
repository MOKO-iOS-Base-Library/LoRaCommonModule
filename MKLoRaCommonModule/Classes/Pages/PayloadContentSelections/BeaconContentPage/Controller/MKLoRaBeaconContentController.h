//
//  MKLoRaBeaconContentController.h
//  MKLoRaCommonModule
//
//  Created by aa on 2026/xx/xx.
//

#import "MKBaseViewController.h"
#import "Pages/PayloadContentSelections/BeaconContentPage/Protocol/MKLoRaBeaconContentPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaBeaconContentController : MKBaseViewController

@property (nonatomic, strong) id <MKLoRaBeaconContentPageProtocol> protocol;
@end

NS_ASSUME_NONNULL_END
