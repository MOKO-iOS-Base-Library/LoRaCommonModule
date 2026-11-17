//
//  MKURLContentController.h
//  MKLoRaCommonModule
//

#import "MKBaseViewController.h"
#import "Pages/PayloadContentSelections/URLContentPage/Protocol/MKURLContentPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKURLContentController : MKBaseViewController

@property (nonatomic, strong) id <MKURLContentPageProtocol> protocol;
@end

NS_ASSUME_NONNULL_END
