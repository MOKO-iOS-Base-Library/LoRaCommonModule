#import "MKBaseViewController.h"
#import "Pages/LCGpsFixPage/Protocol/MKLCGpsFixPageProtocol.h"
NS_ASSUME_NONNULL_BEGIN
@interface MKLCGpsFixController : MKBaseViewController
@property (nonatomic, strong) id <MKLCGpsFixPageProtocol> protocol;
@end
NS_ASSUME_NONNULL_END
