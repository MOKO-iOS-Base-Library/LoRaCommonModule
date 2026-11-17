//
//  MKTLMContentController.h
//  MKLoRaCommonModule
//

#import "MKBaseViewController.h"
#import "Pages/PayloadContentSelections/TLMContentPage/Protocol/MKTLMContentPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKTLMContentController : MKBaseViewController

@property (nonatomic, strong) id <MKTLMContentPageProtocol> protocol;
@end

NS_ASSUME_NONNULL_END
