//
//  MKLoRaGpsFixSettingsController.h
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/22.
//

#import "MKBaseViewController.h"
#import "Pages/GpsFixSettingsPage/Protocol/MKLoRaGpsFixSettingsPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/// GPS Fix Function Settings 页。
/// section2 的 Periodic/Timing/Motion Report Settings 三个入口由子类重写
/// tableView:didSelectRowAtIndexPath: 处理（各业务跳转的页面不同）。
@interface MKLoRaGpsFixSettingsController : MKBaseViewController

@property (nonatomic, strong) id <MKLoRaGpsFixSettingsPageProtocol> protocol;

@end

NS_ASSUME_NONNULL_END
