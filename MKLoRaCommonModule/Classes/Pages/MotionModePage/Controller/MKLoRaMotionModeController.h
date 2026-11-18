//
//  MKLoRaMotionModeController.h
//  MKLoRaCommonModule_Example
//
//  Created by aa on 2026/11/18.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import "MKBaseViewController.h"

#import "Pages/MotionModePage/Protocol/MKLoRaMotionModePageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaMotionModeController : MKBaseViewController

@property (nonatomic, strong)id <MKLoRaMotionModePageProtocol>protocol;

- (NSArray<NSString *> *)motionPosStrategyDataList;
- (NSArray<NSString *> *)motionPosStrategyInTripDataList;

- (NSArray<NSString *> *)motionPosStrategyDataList;
- (NSArray<NSString *> *)motionPosStrategyInTripDataList;

@end

NS_ASSUME_NONNULL_END
