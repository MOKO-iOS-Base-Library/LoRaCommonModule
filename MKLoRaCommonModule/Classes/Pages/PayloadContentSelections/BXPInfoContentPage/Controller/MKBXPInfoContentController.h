//
//  MKBXPInfoContentController.h
//  MKLoRaCommonModule
//

#import "MKBaseViewController.h"
#import "Pages/PayloadContentSelections/BXPInfoContentPage/Protocol/MKBXPInfoContentPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKBXPInfoContentController : MKBaseViewController

@property (nonatomic, strong) id <MKBXPInfoContentPageProtocol> protocol;
@end

NS_ASSUME_NONNULL_END
