#import "MKBaseViewController.h"
#import "Pages/DebuggerPage/Protocol/MKLoRaDebuggerPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaDebuggerController : MKBaseViewController

@property (nonatomic, strong) id <MKLoRaDebuggerPageProtocol> protocol;

@end

NS_ASSUME_NONNULL_END
