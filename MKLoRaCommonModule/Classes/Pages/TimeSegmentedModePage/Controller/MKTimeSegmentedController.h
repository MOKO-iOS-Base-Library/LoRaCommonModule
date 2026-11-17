//
//  MKTimeSegmentedController.h
//  MKLoRaCommonModule_Example
//
//  Created by aa on 2024/11/21.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import "MKBaseViewController.h"

#import "Pages/TimeSegmentedModePage/Protocol/MKTimeSegmentedPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKTimeSegmentedController : MKBaseViewController

@property (nonatomic, strong)id <MKTimeSegmentedPageProtocol>protocol;

- (NSArray<NSString *> *)posStrategyDataList;

- (NSArray<NSString *> *)posStrategyDataList;

@end

NS_ASSUME_NONNULL_END
