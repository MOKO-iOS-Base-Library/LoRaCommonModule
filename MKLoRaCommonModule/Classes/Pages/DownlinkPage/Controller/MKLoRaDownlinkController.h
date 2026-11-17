#import "MKBaseViewController.h"
#import "Pages/DownlinkPage/Protocol/MKLoRaDownlinkPageProtocol.h"
NS_ASSUME_NONNULL_BEGIN
@interface MKLoRaDownlinkController : MKBaseViewController
@property (nonatomic, strong) id <MKLoRaDownlinkPageProtocol> protocol;
@end
NS_ASSUME_NONNULL_END
