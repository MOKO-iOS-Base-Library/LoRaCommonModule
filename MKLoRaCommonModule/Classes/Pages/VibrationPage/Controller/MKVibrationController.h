#import "MKBaseViewController.h"
#import "MKVibrationPageProtocol.h"
NS_ASSUME_NONNULL_BEGIN
@interface MKVibrationController : MKBaseViewController
@property (nonatomic, strong) id <MKVibrationPageProtocol> protocol;
@end
NS_ASSUME_NONNULL_END
