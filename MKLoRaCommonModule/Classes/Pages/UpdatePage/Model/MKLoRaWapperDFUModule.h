//
//  MKLoRaWapperDFUModule.h
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/18.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

/// 基于 MKDFUWapper 的固件升级
@interface MKLoRaWapperDFUModule : NSObject

/// DFU 状态变化通知名，userInfo 中的 isUpdating 标识当前是否正在升级
@property (nonatomic, copy)NSString *stateChangedNotificationName;

- (void)updateWithPeripheral:(CBPeripheral *)peripheral
             disconnectBlock:(void (^)(void))disconnectBlock
                    filePath:(NSString *)filePath
               progressBlock:(void (^)(CGFloat progress))progressBlock
                    sucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock;

- (void)cancelUpdate;

@end

NS_ASSUME_NONNULL_END
