//
//  MKTimingImmediatelyController.h
//  MKLoRaCommonModule_Example
//
//  Created by aa on 2025/5/11.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import "MKBaseViewController.h"
#import "MKTimingImmediatelyPageProtocol.h"
NS_ASSUME_NONNULL_BEGIN
@interface MKTimingImmediatelyController : MKBaseViewController
@property (nonatomic, strong) id <MKTimingImmediatelyPageProtocol> protocol;
- (void)connectTimerRun;
@end
NS_ASSUME_NONNULL_END
