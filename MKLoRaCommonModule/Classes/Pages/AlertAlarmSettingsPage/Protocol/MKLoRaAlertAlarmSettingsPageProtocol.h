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

/*
 0:WIFI
 1:BLE
 2:GPS
 3:WIFI+GPS
 4:BLE+GPS
 5:WIFI+BLE
 6:WIFI+BLE+GPS
 */
@property (nonatomic, assign)NSInteger strategy;

@property (nonatomic, assign)BOOL start;

@property (nonatomic, assign)BOOL end;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
