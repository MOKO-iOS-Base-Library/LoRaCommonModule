#import "MKBaseViewController.h"
#import "Pages/LoRaSettingPage/Protocol/MKLoRaFullSettingPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaFullSettingController : MKBaseViewController

@property (nonatomic, strong)id <MKLoRaFullSettingPageProtocol> protocol;

- (instancetype)initWithProtocol:(id <MKLoRaFullSettingPageProtocol>)protocol;

@end

NS_ASSUME_NONNULL_END
