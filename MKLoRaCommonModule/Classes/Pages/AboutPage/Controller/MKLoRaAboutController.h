//
//  MKLoRaAboutController.h
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/18.
//

#import "MKBaseViewController.h"

#import "Pages/AboutPage/Protocol/MKLoRaAboutPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaAboutController : MKBaseViewController

@property (nonatomic, strong) id <MKLoRaAboutPageProtocol> protocol;

@end

NS_ASSUME_NONNULL_END
