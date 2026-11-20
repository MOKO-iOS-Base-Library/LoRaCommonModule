//
//  MKLoRaPirContentController.h
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/18.
//

#import "MKBaseViewController.h"
#import "Pages/PayloadContentSelections/MKPirContentPage/Protocol/MKLoRaPirContentPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaPirContentController : MKBaseViewController

@property (nonatomic, strong) id <MKLoRaPirContentPageProtocol> protocol;
@end

NS_ASSUME_NONNULL_END
