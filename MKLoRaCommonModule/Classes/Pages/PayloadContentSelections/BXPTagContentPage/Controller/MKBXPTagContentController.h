//
//  MKBXPTagContentController.h
//  MKLoRaCommonModule
//

#import "MKBaseViewController.h"
#import "Pages/PayloadContentSelections/BXPTagContentPage/Protocol/MKBXPTagContentPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKBXPTagContentController : MKBaseViewController

@property (nonatomic, strong) id <MKBXPTagContentPageProtocol> protocol;
@end

NS_ASSUME_NONNULL_END
