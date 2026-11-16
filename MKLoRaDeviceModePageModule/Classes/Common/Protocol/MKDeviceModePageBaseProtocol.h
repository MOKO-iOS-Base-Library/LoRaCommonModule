//
//  MKDeviceModePageBaseProtocol.h
//  MKLoRaDeviceModePageModule
//
//  Created by Trae on 2026/11/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 设备模式页面公共基协议。
/// 所有子类协议（Motion/Periodic/Standby/Timing/TimeSegmented）均继承本协议，
/// 从而保证统一的读/写接口签名。
@protocol MKDeviceModePageBaseProtocol <NSObject>

/// 从设备读取当前模式数据。
- (void)readDataWithSucBlock:(void (^)(void))sucBlock
                  failedBlock:(void (^)(NSError * _Nonnull error))failedBlock;

/// 将当前模式数据写入设备。
/// 注：Timing / TimeSegmented 页面因配置参数更复杂，子类协议使用专门的
/// `configData:pointList sucBlock:failedBlock:` 签名，子类协议需同时实现
/// 本协议的 `configDataWithSucBlock:failedBlock:`（可以转发到专门签名）。
- (void)configDataWithSucBlock:(void (^)(void))sucBlock
                   failedBlock:(void (^)(NSError * _Nonnull error))failedBlock;

@end

NS_ASSUME_NONNULL_END
