//
//  MKPirContentController.h
//  MKLoRaCommonModule
//

#import "MKBaseViewController.h"
#import "Pages/PayloadContentSelections/MKPirContentPage/Protocol/MKPirContentPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKPirContentController : MKBaseViewController

@property (nonatomic, strong) id <MKPirContentPageProtocol> protocol;
@end

NS_ASSUME_NONNULL_END
