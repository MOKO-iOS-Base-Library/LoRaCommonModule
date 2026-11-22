//
//  MKLoRaURLContentController.h
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/18.
//

#import "MKBaseViewController.h"
#import "Pages/PayloadContentSelections/URLContentPage/Protocol/MKLoRaURLContentPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaURLContentController : MKBaseViewController

@property (nonatomic, strong) id <MKLoRaURLContentPageProtocol> protocol;
@end

NS_ASSUME_NONNULL_END
