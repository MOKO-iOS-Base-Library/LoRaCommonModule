//
//  MKLoRaScanTimingController.h
//  MKLoRaCommonModule_Example
//
//  Created by aa on 2026/11/18.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import "MKBaseViewController.h"
#import "Pages/ScanTimingPage/Protocol/MKLoRaScanTimingPageProtocol.h"
NS_ASSUME_NONNULL_BEGIN
@interface MKLoRaScanTimingController : MKBaseViewController
@property (nonatomic, strong) id <MKLoRaScanTimingPageProtocol> protocol;
- (void)connectTimerRun;
@end
NS_ASSUME_NONNULL_END
