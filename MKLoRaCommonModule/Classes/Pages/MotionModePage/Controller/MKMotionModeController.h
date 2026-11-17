//
//  MKMotionModeController.h
//  MKLoRaCommonModule_Example
//
//  Created by aa on 2025/5/11.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import "MKBaseViewController.h"

#import "MKMotionModePageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKMotionModeController : MKBaseViewController

@property (nonatomic, strong)id <MKMotionModePageProtocol>protocol;

- (NSArray<NSString *> *)motionPosStrategyDataList;
- (NSArray<NSString *> *)motionPosStrategyInTripDataList;

- (NSArray<NSString *> *)motionPosStrategyDataList;
- (NSArray<NSString *> *)motionPosStrategyInTripDataList;

@end

NS_ASSUME_NONNULL_END
