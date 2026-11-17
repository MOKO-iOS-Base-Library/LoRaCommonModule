//
//  MKUIDContentController.h
//  MKLoRaCommonModule
//

#import "MKBaseViewController.h"
#import "Pages/PayloadContentSelections/UIDContentPage/Protocol/MKUIDContentPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKUIDContentController : MKBaseViewController

@property (nonatomic, strong) id <MKUIDContentPageProtocol> protocol;
@end

NS_ASSUME_NONNULL_END
