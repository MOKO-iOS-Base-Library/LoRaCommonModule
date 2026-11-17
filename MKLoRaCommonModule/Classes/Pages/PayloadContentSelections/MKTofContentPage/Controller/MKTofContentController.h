//
//  MKTofContentController.h
//  MKLoRaCommonModule
//

#import "MKBaseViewController.h"
#import "MKTofContentPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKTofContentController : MKBaseViewController

@property (nonatomic, strong) id <MKTofContentPageProtocol> protocol;
@end

NS_ASSUME_NONNULL_END
