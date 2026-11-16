//
//  MKAxisSettingController.h
//  MKLoRaCommonModule
//
//  Created by aa on 2025/xx/xx.
//

#import "MKBaseViewController.h"
#import "MKAxisSettingPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKAxisSettingController : MKBaseViewController

@property (nonatomic, strong) id <MKAxisSettingPageProtocol> protocol;

@end

NS_ASSUME_NONNULL_END
