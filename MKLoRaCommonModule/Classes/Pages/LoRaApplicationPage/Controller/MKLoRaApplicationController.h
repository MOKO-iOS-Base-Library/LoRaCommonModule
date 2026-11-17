#import "MKBaseViewController.h"
#import "Pages/LoRaApplicationPage/Protocol/MKLoRaApplicationPageProtocol.h"
NS_ASSUME_NONNULL_BEGIN
@interface MKLoRaApplicationController : MKBaseViewController
@property (nonatomic, strong) id <MKLoRaApplicationPageProtocol> protocol;
@end
NS_ASSUME_NONNULL_END
