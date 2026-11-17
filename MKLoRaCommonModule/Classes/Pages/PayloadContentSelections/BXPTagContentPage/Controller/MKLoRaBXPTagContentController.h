//
//  MKLoRaBXPTagContentController.h
//  MKLoRaCommonModule
//

#import "MKBaseViewController.h"
#import "Pages/PayloadContentSelections/BXPTagContentPage/Protocol/MKLoRaBXPTagContentPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaBXPTagContentController : MKBaseViewController

@property (nonatomic, strong) id <MKLoRaBXPTagContentPageProtocol> protocol;
@end

NS_ASSUME_NONNULL_END
