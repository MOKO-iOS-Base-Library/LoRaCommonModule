//
//  MKNanoBeaconContentController.h
//  MKLoRaCommonModule
//

#import "MKBaseViewController.h"
#import "Pages/PayloadContentSelections/NanoBeaconContentPage/Protocol/MKNanoBeaconContentPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKNanoBeaconContentController : MKBaseViewController

@property (nonatomic, strong) id <MKNanoBeaconContentPageProtocol> protocol;
@end

NS_ASSUME_NONNULL_END
