//
//  MKTimingReportPageProtocol.h
//  MKLoRaCommonModule_Example
//
//  Created by aa on 2025/5/11.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import "MKScanTimePointModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MKTimingReportPageProtocol <NSObject>

@property (nonatomic, copy)NSString *duration;

@property (nonatomic, strong)NSArray <MKScanTimePointModel *>*scanPointList;

@property (nonatomic, strong)NSArray <MKScanTimePointModel *>*reportPointList;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configScanPointList:(NSArray <MKScanTimePointModel *>*)scanList
            reportPointList:(NSArray <MKScanTimePointModel *>*)reportList
                   sucBlock:(void (^)(void))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
