#import "MKBaseViewController.h"
#import "Pages/VibrationPage/Protocol/MKLoRaVibrationPageProtocol.h"
NS_ASSUME_NONNULL_BEGIN
@interface MKLoRaVibrationController : MKBaseViewController
@property (nonatomic, strong) id <MKLoRaVibrationPageProtocol> protocol;
@end
NS_ASSUME_NONNULL_END
