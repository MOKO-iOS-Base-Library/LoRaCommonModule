//
//  MKLoRaTimingReportController.h
//  MKLoRaCommonModule_Example
//
//  Created by aa on 2025/5/11.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import "MKBaseViewController.h"
#import "Pages/TimingReportPage/Protocol/MKLoRaTimingReportPageProtocol.h"
NS_ASSUME_NONNULL_BEGIN
@interface MKLoRaTimingReportController : MKBaseViewController
@property (nonatomic, strong) id <MKLoRaTimingReportPageProtocol> protocol;
- (void)connectTimerRun;
@end
NS_ASSUME_NONNULL_END
