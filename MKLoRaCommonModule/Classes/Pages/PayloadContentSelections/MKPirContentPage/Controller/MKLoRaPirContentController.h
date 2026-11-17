//
//  MKLoRaPirContentController.h
//  MKLoRaCommonModule
//

#import "MKBaseViewController.h"
#import "Pages/PayloadContentSelections/MKPirContentPage/Protocol/MKLoRaPirContentPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaPirContentController : MKBaseViewController

@property (nonatomic, strong) id <MKLoRaPirContentPageProtocol> protocol;
@end

NS_ASSUME_NONNULL_END
