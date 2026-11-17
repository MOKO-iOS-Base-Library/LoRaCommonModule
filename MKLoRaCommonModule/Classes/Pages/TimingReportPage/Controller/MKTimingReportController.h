//
//  MKTimingReportController.h
//  MKLoRaCommonModule_Example
//
//  Created by aa on 2025/5/11.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import "MKBaseViewController.h"
#import "MKTimingReportPageProtocol.h"
NS_ASSUME_NONNULL_BEGIN
@interface MKTimingReportController : MKBaseViewController
@property (nonatomic, strong) id <MKTimingReportPageProtocol> protocol;
- (void)connectTimerRun;
@end
NS_ASSUME_NONNULL_END
