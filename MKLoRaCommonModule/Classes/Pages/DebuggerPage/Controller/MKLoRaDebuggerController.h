#import "MKBaseViewController.h"
#import "Pages/DebuggerPage/Protocol/MKLoRaDebuggerPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaDebuggerController : MKBaseViewController

@property (nonatomic, strong) id <MKLoRaDebuggerPageProtocol> protocol;

/// 设备 mac 地址，设置后透传给 protocol
@property (nonatomic, copy) NSString *macAddress;

@end

NS_ASSUME_NONNULL_END
