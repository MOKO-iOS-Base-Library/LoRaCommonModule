//
//  MKOtherTypeContentController.h
//  MKLoRaCommonModule
//

#import "MKBaseViewController.h"
#import "MKOtherTypeContentPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKOtherTypeContentController : MKBaseViewController

@property (nonatomic, strong) id <MKOtherTypeContentPageProtocol> protocol;
@end

NS_ASSUME_NONNULL_END
