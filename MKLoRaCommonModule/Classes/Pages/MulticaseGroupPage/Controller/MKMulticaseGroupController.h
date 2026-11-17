//
//  MKMulticaseGroupController.h
//  MKLoRaCommonModule
//

#import "MKBaseViewController.h"
#import "Pages/MulticaseGroupPage/Protocol/MKMulticaseGroupPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKMulticaseGroupController : MKBaseViewController

@property (nonatomic, strong) id <MKMulticaseGroupPageProtocol> protocol;
@end

NS_ASSUME_NONNULL_END
