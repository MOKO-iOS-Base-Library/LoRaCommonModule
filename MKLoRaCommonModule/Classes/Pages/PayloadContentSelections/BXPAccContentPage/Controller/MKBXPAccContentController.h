//
//  MKBXPAccContentController.h
//  MKLoRaCommonModule
//

#import "MKBaseViewController.h"
#import "MKBXPAccContentPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKBXPAccContentController : MKBaseViewController

@property (nonatomic, strong) id <MKBXPAccContentPageProtocol> protocol;
@end

NS_ASSUME_NONNULL_END
