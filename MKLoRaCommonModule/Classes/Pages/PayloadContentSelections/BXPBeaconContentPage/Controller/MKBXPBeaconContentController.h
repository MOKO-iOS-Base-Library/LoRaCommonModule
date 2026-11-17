//
//  MKBXPBeaconContentController.h
//  MKLoRaCommonModule
//

#import "MKBaseViewController.h"
#import "MKBXPBeaconContentPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKBXPBeaconContentController : MKBaseViewController

@property (nonatomic, strong) id <MKBXPBeaconContentPageProtocol> protocol;
@end

NS_ASSUME_NONNULL_END
