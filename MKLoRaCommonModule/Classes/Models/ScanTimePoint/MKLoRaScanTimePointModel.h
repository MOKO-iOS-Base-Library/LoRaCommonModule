//
//  MKLoRaScanTimePointModel.h
//  MKLoRaCommonModule_Example
//
//  Created by aa on 2026/11/18.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaScanTimePointModel : NSObject

/// 0~23
@property (nonatomic, assign)NSInteger hour;

/// 0~5，依次对应00/10/20/30/40/50分
@property (nonatomic, assign)NSInteger minuteGear;

@end

NS_ASSUME_NONNULL_END
