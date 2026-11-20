//
//  MKLoRaBXPInfoContentController.h
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/18.
//

#import "MKBaseViewController.h"
#import "Pages/PayloadContentSelections/BXPInfoContentPage/Protocol/MKLoRaBXPInfoContentPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaBXPInfoContentController : MKBaseViewController

@property (nonatomic, strong) id <MKLoRaBXPInfoContentPageProtocol> protocol;
@end

NS_ASSUME_NONNULL_END
