//
//  MKLoRaTimeSegmentedController.h
//  MKLoRaCommonModule_Example
//
//  Created by aa on 2026/11/18.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import "MKBaseViewController.h"

#import "Pages/TimeSegmentedModePage/Protocol/MKLoRaTimeSegmentedPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaTimeSegmentedController : MKBaseViewController

@property (nonatomic, strong)id <MKLoRaTimeSegmentedPageProtocol>protocol;

- (NSArray<NSString *> *)posStrategyDataList;

- (NSArray<NSString *> *)posStrategyDataList;

@end

NS_ASSUME_NONNULL_END
