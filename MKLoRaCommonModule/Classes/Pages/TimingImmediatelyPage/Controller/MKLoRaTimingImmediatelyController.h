//
//  MKLoRaTimingImmediatelyController.h
//  MKLoRaCommonModule_Example
//
//  Created by aa on 2026/11/18.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import "MKBaseViewController.h"
#import "Pages/TimingImmediatelyPage/Protocol/MKLoRaTimingImmediatelyPageProtocol.h"
NS_ASSUME_NONNULL_BEGIN
@interface MKLoRaTimingImmediatelyController : MKBaseViewController
@property (nonatomic, strong) id <MKLoRaTimingImmediatelyPageProtocol> protocol;
- (void)connectTimerRun;
@end
NS_ASSUME_NONNULL_END
