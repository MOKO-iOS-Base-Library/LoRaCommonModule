#import "MKBaseViewController.h"
#import "Pages/LCGpsFixPage/Protocol/MKLoRaLCGpsFixPageProtocol.h"
NS_ASSUME_NONNULL_BEGIN
@interface MKLoRaLCGpsFixController : MKBaseViewController
@property (nonatomic, strong) id <MKLoRaLCGpsFixPageProtocol> protocol;
@end
NS_ASSUME_NONNULL_END
