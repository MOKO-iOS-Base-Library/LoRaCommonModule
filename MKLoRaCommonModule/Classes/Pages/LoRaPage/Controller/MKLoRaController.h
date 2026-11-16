#import "MKBaseViewController.h"
#import "MKLoRaPageProtocol.h"
NS_ASSUME_NONNULL_BEGIN
@interface MKLoRaController : MKBaseViewController
@property (nonatomic, strong) id <MKLoRaPageProtocol> protocol;
@end
NS_ASSUME_NONNULL_END
