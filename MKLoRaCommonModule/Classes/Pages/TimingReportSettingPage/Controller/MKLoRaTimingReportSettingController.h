//
//  MKLoRaTimingReportSettingController.h
//  MKLoRaCommonModule_Example
//
//  Created by aa on 2026/11/18.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import "MKBaseViewController.h"
#import "Pages/TimingReportSettingPage/Protocol/MKLoRaTimingReportSettingPageProtocol.h"
NS_ASSUME_NONNULL_BEGIN
@interface MKLoRaTimingReportSettingController : MKBaseViewController
@property (nonatomic, strong) id <MKLoRaTimingReportSettingPageProtocol> protocol;
@end
NS_ASSUME_NONNULL_END
