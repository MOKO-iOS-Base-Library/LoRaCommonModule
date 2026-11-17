#import "MKBaseViewController.h"
#import "Pages/PayloadContentPage/Protocol/MKPayloadContentPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKPayloadContentController : MKBaseViewController

@property (nonatomic, strong) id <MKPayloadContentPageProtocol> protocol;

@end

NS_ASSUME_NONNULL_END
