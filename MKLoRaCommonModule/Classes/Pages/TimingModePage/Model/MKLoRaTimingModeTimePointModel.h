//
//  MKLoRaTimingModeTimePointModel.h
//  MKLoRaCommonModule_Example
//
//  Created by aa on 2026/11/18.
//  Copyright © 2025 lovexiaoxia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaTimingModeTimePointModel : NSObject

/// 0~23
@property (nonatomic, assign)NSInteger hour;

/// 0-59
@property (nonatomic, assign)NSInteger minuteGear;

@end

NS_ASSUME_NONNULL_END
