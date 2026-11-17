//
//  MKTimingModeController.h
//  MKLoRaCommonModule_Example
//
//  Created by aa on 2025/5/11.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import "MKBaseViewController.h"

#import "MKTimingModePageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKTimingModeController : MKBaseViewController

@property (nonatomic, strong)id <MKTimingModePageProtocol>protocol;

- (NSArray<NSString *> *)posStrategyDataList;

- (NSArray<NSString *> *)posStrategyDataList;

@end

NS_ASSUME_NONNULL_END
