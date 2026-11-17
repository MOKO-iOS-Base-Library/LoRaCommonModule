#import "MKBaseViewController.h"
#import "Pages/LoRaSettingPage/Protocol/MKLoRaSettingPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaSettingController : MKBaseViewController

@property (nonatomic, strong) id <MKLoRaSettingPageProtocol> protocol;

@end

NS_ASSUME_NONNULL_END
