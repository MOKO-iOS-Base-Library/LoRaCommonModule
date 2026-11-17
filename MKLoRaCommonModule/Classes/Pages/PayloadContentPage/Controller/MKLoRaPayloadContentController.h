#import "MKBaseViewController.h"
#import "Pages/PayloadContentPage/Protocol/MKLoRaPayloadContentPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaPayloadContentController : MKBaseViewController

@property (nonatomic, strong) id <MKLoRaPayloadContentPageProtocol> protocol;

@end

NS_ASSUME_NONNULL_END
