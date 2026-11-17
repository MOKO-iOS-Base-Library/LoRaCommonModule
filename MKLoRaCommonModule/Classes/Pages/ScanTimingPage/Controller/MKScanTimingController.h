//
//  MKScanTimingController.h
//  MKLoRaCommonModule_Example
//
//  Created by aa on 2025/5/11.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import "MKBaseViewController.h"
#import "Pages/ScanTimingPage/Protocol/MKScanTimingPageProtocol.h"
NS_ASSUME_NONNULL_BEGIN
@interface MKScanTimingController : MKBaseViewController
@property (nonatomic, strong) id <MKScanTimingPageProtocol> protocol;
- (void)connectTimerRun;
@end
NS_ASSUME_NONNULL_END
