//
//  MKLoRaStandbyModeController.h
//  MKLoRaCommonModule_Example
//
//  Created by aa on 2026/11/18.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import "MKBaseViewController.h"

#import "Pages/StandbyModePage/Protocol/MKLoRaStandbyModePageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaStandbyModeController : MKBaseViewController

@property (nonatomic, strong)id <MKLoRaStandbyModePageProtocol>protocol;

- (NSArray<NSString *> *)posStrategyDataList;

- (NSArray<NSString *> *)posStrategyDataList;

@end

NS_ASSUME_NONNULL_END
