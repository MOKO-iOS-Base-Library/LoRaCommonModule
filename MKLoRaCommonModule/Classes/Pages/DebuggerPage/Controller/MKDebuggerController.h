#import "MKBaseViewController.h"
#import "Pages/DebuggerPage/Protocol/MKDebuggerPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKDebuggerController : MKBaseViewController

@property (nonatomic, strong) id <MKDebuggerPageProtocol> protocol;

@end

NS_ASSUME_NONNULL_END
