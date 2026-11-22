//
//  MKLoRaAlertAlarmSettingsPageProtocol.h
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKLoRaAlertAlarmSettingsPageProtocol <NSObject>

/// 0:Single Click  1:Double Click  2:Long Press 1s 3:Long Press 2s 4:Long Press 3s
@property (nonatomic, assign)NSInteger mode;

/// Positioning Strategy，索引对应 strategyDataList 中的可选项
@property (nonatomic, assign)NSInteger strategy;

@property (nonatomic, assign)BOOL start;

@property (nonatomic, assign)BOOL end;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@optional

/// Positioning Strategy 下拉列表，不实现时使用默认列表
@property (nonatomic, copy)NSArray<NSString *> *strategyDataList;

@end

NS_ASSUME_NONNULL_END
