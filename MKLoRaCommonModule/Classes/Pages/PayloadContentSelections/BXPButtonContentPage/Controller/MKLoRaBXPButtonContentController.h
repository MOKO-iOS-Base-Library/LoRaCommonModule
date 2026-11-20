//
//  MKLoRaBXPButtonContentController.h
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/18.
//

#import "MKBaseViewController.h"
#import "Pages/PayloadContentSelections/BXPButtonContentPage/Protocol/MKLoRaBXPButtonContentPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaBXPButtonContentController : MKBaseViewController

@property (nonatomic, strong) id <MKLoRaBXPButtonContentPageProtocol> protocol;
@end

NS_ASSUME_NONNULL_END
