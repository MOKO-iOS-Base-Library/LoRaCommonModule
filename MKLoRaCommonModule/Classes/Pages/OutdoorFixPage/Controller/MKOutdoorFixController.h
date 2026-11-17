#import "MKBaseViewController.h"
#import "Pages/OutdoorFixPage/Protocol/MKOutdoorFixPageProtocol.h"
NS_ASSUME_NONNULL_BEGIN
@interface MKOutdoorFixController : MKBaseViewController
@property (nonatomic, strong) id <MKOutdoorFixPageProtocol> protocol;
@end
NS_ASSUME_NONNULL_END
