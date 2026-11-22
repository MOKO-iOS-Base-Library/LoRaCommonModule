//
//  MKLoRaDeviceInfoPageProtocol.h
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKLoRaDeviceInfoPageProtocol <NSObject>

/// 软件版本（所有模块都有）
@property (nonatomic, copy) NSString *software;

/// 固件版本（所有模块都有）
@property (nonatomic, copy) NSString *firmware;

/// 硬件版本（所有模块都有）
@property (nonatomic, copy) NSString *hardware;

/// 电池电压/电量（所有模块都有，部分模块字段名为 battery）
@property (nonatomic, copy) NSString *voltage;

/// MAC 地址（所有模块都有）
@property (nonatomic, copy) NSString *macAddress;

/// 产品型号（所有模块都有）
@property (nonatomic, copy) NSString *productMode;

/// 厂商信息（所有模块都有）
@property (nonatomic, copy) NSString *manu;

/// 读取设备信息
- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@optional

/// 电池电压显示文本（含单位）。不实现则默认 voltage + "mV"。
/// 例如 AF 返回 [NSString stringWithFormat:@"%@ V", self.voltage]。
- (nullable NSString *)deviceInfoPageVoltageDisplayText;

#pragma mark - Cellular 专属字段
/// ICCID（仅 MKCellular 等 Cellular 模块有）
@property (nonatomic, copy, nullable) NSString *iccid;
/// IMEI（仅 MKCellular 等 Cellular 模块有）
@property (nonatomic, copy, nullable) NSString *imei;

#pragma mark - 业务 push 子页面入口
/// 固件版本行点击（业务可以 push DFU 页面；返回 YES 表示业务处理了）
- (BOOL)deviceInfoPageShouldHandleFirmwareTap;

/// Battery Consumption Information 入口点击
- (void)deviceInfoPageDidSelectBatteryConsumption;

/// Debugger Mode 入口点击
- (void)deviceInfoPageDidSelectDebuggerWithMacAddress:(NSString *)macAddress;

/// 三击手势（Selftest）
- (void)deviceInfoPageDidTripleTap;

/// 是否需要监听 DFU 开始通知
- (BOOL)deviceInfoPageShouldObserveDFUNotification;

/// DFU 开始通知名，与 UpdatePage 的 mk_lora_update_startDfuNotificationName 对应。
/// 不实现则使用默认通知名 mk_loraModule_deviceInfo_startDfuProcessNotification。
- (nullable NSString *)deviceInfoPageStartDfuNotificationName;

#pragma mark - Decoder Export
/// 是否显示 Decoder Export 行（位于 Debugger Mode 下方），默认 NO
@property (nonatomic, assign)BOOL supportDecoderExport;

/// Decoder Export 行点击，业务自行处理导出逻辑
- (void)deviceInfoPageDidSelectDecoderExport;

@end

NS_ASSUME_NONNULL_END
