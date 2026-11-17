//
//  MKTimingReportSettingPageProtocol.h
//  MKLoRaCommonModule_Example
//
//  Created by aa on 2025/5/11.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKTimingReportSettingTimePointModel : NSObject

/// 0~23
@property (nonatomic, assign)NSInteger hour;

/// 0 ~ 59
@property (nonatomic, assign)NSInteger minuteGear;

@end

@protocol MKTimingReportSettingPageProtocol <NSObject>

@property (nonatomic, strong)NSArray <MKTimingReportSettingTimePointModel *>*pointList;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configData:(NSArray <MKTimingReportSettingTimePointModel *>*)pointList
          sucBlock:(void (^)(void))sucBlock
       failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
