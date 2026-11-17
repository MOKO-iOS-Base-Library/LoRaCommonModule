//
//  MKLoRaOtherTypeContentController.h
//  MKLoRaCommonModule
//

#import "MKBaseViewController.h"
#import "Pages/PayloadContentSelections/OtherTypeContentPage/Protocol/MKLoRaOtherTypeContentPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaOtherTypeContentController : MKBaseViewController

@property (nonatomic, strong) id <MKLoRaOtherTypeContentPageProtocol> protocol;
@end

NS_ASSUME_NONNULL_END
