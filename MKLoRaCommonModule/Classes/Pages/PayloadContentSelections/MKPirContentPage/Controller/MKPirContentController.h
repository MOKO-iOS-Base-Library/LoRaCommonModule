//
//  MKPirContentController.h
//  MKLoRaCommonModule
//

#import "MKBaseViewController.h"
#import "MKPirContentPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKPirContentController : MKBaseViewController

@property (nonatomic, strong) id <MKPirContentPageProtocol> protocol;
@end

NS_ASSUME_NONNULL_END
