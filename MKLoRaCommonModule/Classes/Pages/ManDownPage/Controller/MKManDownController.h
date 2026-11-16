//
//  MKManDownController.h
//  MKLoRaCommonModule
//
//  Created by aa on 2025/xx/xx.
//

#import "MKBaseViewController.h"
#import "MKManDownPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKManDownController : MKBaseViewController

@property (nonatomic, strong) id <MKManDownPageProtocol> protocol;

@end

NS_ASSUME_NONNULL_END
