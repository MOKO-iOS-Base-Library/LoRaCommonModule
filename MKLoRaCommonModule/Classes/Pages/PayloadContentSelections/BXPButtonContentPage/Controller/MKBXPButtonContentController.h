//
//  MKBXPButtonContentController.h
//  MKLoRaCommonModule
//

#import "MKBaseViewController.h"
#import "Pages/PayloadContentSelections/BXPButtonContentPage/Protocol/MKBXPButtonContentPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKBXPButtonContentController : MKBaseViewController

@property (nonatomic, strong) id <MKBXPButtonContentPageProtocol> protocol;
@end

NS_ASSUME_NONNULL_END
