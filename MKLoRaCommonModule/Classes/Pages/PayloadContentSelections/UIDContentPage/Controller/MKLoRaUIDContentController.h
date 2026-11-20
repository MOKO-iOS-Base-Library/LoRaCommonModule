//
//  MKLoRaUIDContentController.h
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/18.
//

#import "MKBaseViewController.h"
#import "Pages/PayloadContentSelections/UIDContentPage/Protocol/MKLoRaUIDContentPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaUIDContentController : MKBaseViewController

@property (nonatomic, strong) id <MKLoRaUIDContentPageProtocol> protocol;
@end

NS_ASSUME_NONNULL_END
