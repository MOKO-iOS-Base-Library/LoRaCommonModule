//
//  MKLoRaBXPTHContentController.h
//  MKLoRaCommonModule
//

#import "MKBaseViewController.h"
#import "Pages/PayloadContentSelections/BXPTHContentPage/Protocol/MKLoRaBXPTHContentPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaBXPTHContentController : MKBaseViewController

@property (nonatomic, strong) id <MKLoRaBXPTHContentPageProtocol> protocol;
@end

NS_ASSUME_NONNULL_END
