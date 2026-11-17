#import "MKBaseViewController.h"
#import "Pages/OutdoorFixPage/Protocol/MKLoRaOutdoorFixPageProtocol.h"
NS_ASSUME_NONNULL_BEGIN
@interface MKLoRaOutdoorFixController : MKBaseViewController
@property (nonatomic, strong) id <MKLoRaOutdoorFixPageProtocol> protocol;
@end
NS_ASSUME_NONNULL_END
