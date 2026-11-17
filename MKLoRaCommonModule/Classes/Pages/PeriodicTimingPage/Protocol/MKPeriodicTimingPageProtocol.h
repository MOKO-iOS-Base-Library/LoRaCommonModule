//
//  MKPeriodicTimingPageProtocol.h
//  MKLoRaCommonModule_Example
//
//  Created by aa on 2025/5/11.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import "MKScanTimePointModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MKPeriodicTimingPageProtocol <NSObject>

@property (nonatomic, copy)NSString *duration;

@property (nonatomic, copy)NSString *interval;

@property (nonatomic, strong)NSArray <MKScanTimePointModel *>*pointList;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configData:(NSArray <MKScanTimePointModel *>*)pointList
          sucBlock:(void (^)(void))sucBlock
       failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
