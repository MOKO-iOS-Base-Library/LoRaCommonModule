//
//  MKLoRaBXPAccContentController.h
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/18.
//

#import "MKBaseViewController.h"
#import "Pages/PayloadContentSelections/BXPAccContentPage/Protocol/MKLoRaBXPAccContentPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaBXPAccContentController : MKBaseViewController

@property (nonatomic, strong) id <MKLoRaBXPAccContentPageProtocol> protocol;
@end

NS_ASSUME_NONNULL_END
