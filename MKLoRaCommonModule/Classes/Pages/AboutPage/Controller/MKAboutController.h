//
//  MKAboutController.h
//  MKLoRaCommonModule
//
//  Created by aa on 2025/xx/xx.
//

#import "MKBaseViewController.h"

#import "MKAboutPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKAboutController : MKBaseViewController

@property (nonatomic, strong) id <MKAboutPageProtocol> protocol;

@end

NS_ASSUME_NONNULL_END
