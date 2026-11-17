//
//  MKLoRaTLMContentController.h
//  MKLoRaCommonModule
//

#import "MKBaseViewController.h"
#import "Pages/PayloadContentSelections/TLMContentPage/Protocol/MKLoRaTLMContentPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaTLMContentController : MKBaseViewController

@property (nonatomic, strong) id <MKLoRaTLMContentPageProtocol> protocol;
@end

NS_ASSUME_NONNULL_END
