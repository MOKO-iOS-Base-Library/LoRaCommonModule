//
//  MKLoRaAlarmFunctionPageProtocol.h
//  MKLoRaCommonModule
//
//  Created by aa on 2025/xx/xx.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKLoRaAlarmFunctionPageProtocol <NSObject>

/// 0:No  1:Alert  2:SOS
@property (nonatomic, assign)NSInteger alarmType;

@property (nonatomic, copy)NSString *exitTime;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
