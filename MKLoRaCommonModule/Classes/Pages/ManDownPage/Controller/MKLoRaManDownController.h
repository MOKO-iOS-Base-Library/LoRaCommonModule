//
//  MKLoRaManDownController.h
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/18.
//

#import "MKBaseViewController.h"
#import "Pages/ManDownPage/Protocol/MKLoRaManDownPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaManDownController : MKBaseViewController

@property (nonatomic, strong) id <MKLoRaManDownPageProtocol> protocol;

@end

NS_ASSUME_NONNULL_END
