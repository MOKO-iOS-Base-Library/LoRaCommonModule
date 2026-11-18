//
//  MKLoRaAxisSettingController.h
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/18.
//

#import "MKBaseViewController.h"
#import "Pages/AxisSettingPage/Protocol/MKLoRaAxisSettingPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaAxisSettingController : MKBaseViewController

@property (nonatomic, strong) id <MKLoRaAxisSettingPageProtocol> protocol;

@end

NS_ASSUME_NONNULL_END
