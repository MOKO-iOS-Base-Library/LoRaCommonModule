//
//  MKLoRaMulticaseGroupController.h
//  MKLoRaCommonModule
//

#import "MKBaseViewController.h"
#import "Pages/MulticaseGroupPage/Protocol/MKLoRaMulticaseGroupPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaMulticaseGroupController : MKBaseViewController

@property (nonatomic, strong) id <MKLoRaMulticaseGroupPageProtocol> protocol;
@end

NS_ASSUME_NONNULL_END
