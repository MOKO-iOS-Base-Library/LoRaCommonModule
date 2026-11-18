//
//  MKLoRaUpdatePageProtocol.h
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/18.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

/// OTA 升级页面数据协议，各模块提供设备信息即可
@protocol MKLoRaUpdatePageProtocol <NSObject>

/// 是否使用 MKDFUWapper 进行升级，返回 NO 使用 NordicDFU
- (BOOL)mk_lora_update_useDFUWapper;

/// 当前连接的设备
- (CBPeripheral *)mk_lora_update_peripheral;

@optional

/// 使用 MKDFUWapper 升级前断开 App 的 BLE 连接
- (void)mk_lora_update_disconnect;

/// NordicDFU 升级到上传阶段时释放中央管理器
- (void)mk_lora_update_centralManagerDealloc;

/// DFU 开始前的通知名，不实现则不发送通知
- (nullable NSString *)mk_lora_update_startDfuNotificationName;

/// DFU 状态变化通知名，userInfo 中的 isUpdating 标识当前是否正在升级
- (nullable NSString *)mk_lora_update_dfuStateChangedNotificationName;

/// 升级结束后的清理，例如释放中央管理器、发送模块通知
- (void)mk_lora_update_cleanUpAfterUpdate;

@end

NS_ASSUME_NONNULL_END
