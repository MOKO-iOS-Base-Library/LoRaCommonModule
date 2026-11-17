//
//  MKBXPTHContentController.h
//  MKLoRaCommonModule
//

#import "MKBaseViewController.h"
#import "MKBXPTHContentPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKBXPTHContentController : MKBaseViewController

@property (nonatomic, strong) id <MKBXPTHContentPageProtocol> protocol;
@end

NS_ASSUME_NONNULL_END
