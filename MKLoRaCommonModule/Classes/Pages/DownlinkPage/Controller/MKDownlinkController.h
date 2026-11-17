#import "MKBaseViewController.h"
#import "Pages/DownlinkPage/Protocol/MKDownlinkPageProtocol.h"
NS_ASSUME_NONNULL_BEGIN
@interface MKDownlinkController : MKBaseViewController
@property (nonatomic, strong) id <MKDownlinkPageProtocol> protocol;
@end
NS_ASSUME_NONNULL_END
