//
//  MKLoRaFilterSettingController.h
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/23.
//

#import "MKBaseViewController.h"
#import "Pages/FilterSettingPage/Protocol/MKLoRaFilterSettingPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaFilterSettingController : MKBaseViewController

@property (nonatomic, strong) id <MKLoRaFilterSettingPageProtocol> protocol;

@end

NS_ASSUME_NONNULL_END
