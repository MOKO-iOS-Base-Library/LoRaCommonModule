//
//  MKLoRaScanTimePointModel.h
//  MKLoRaCommonModule_Example
//
//  Created by aa on 2025/5/11.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaScanTimePointModel : NSObject

/// 0~23
@property (nonatomic, assign)NSInteger hour;

/// 0:00   1:10   2:20   3:30    4:40   5:50
@property (nonatomic, assign)NSInteger minuteGear;

@end

NS_ASSUME_NONNULL_END
