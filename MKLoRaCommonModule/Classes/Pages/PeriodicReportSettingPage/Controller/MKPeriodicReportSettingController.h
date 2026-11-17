//
//  MKPeriodicReportSettingController.h
//  MKLoRaCommonModule_Example
//
//  Created by aa on 2025/5/11.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import "MKBaseViewController.h"
#import "Pages/PeriodicReportSettingPage/Protocol/MKPeriodicReportSettingPageProtocol.h"
NS_ASSUME_NONNULL_BEGIN
@interface MKPeriodicReportSettingController : MKBaseViewController
@property (nonatomic, strong) id <MKPeriodicReportSettingPageProtocol> protocol;
@end
NS_ASSUME_NONNULL_END
