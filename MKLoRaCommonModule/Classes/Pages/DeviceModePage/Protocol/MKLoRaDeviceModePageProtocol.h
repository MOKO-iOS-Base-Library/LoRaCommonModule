//
//  MKLoRaDeviceModePageProtocol.h
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKLoRaDeviceModePageProtocol <NSObject>

/// 当前设备模式索引，对应 deviceModeDataList
@property (nonatomic, assign) NSInteger mode;

/// 读取当前设备模式
- (void)readWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

/// 切换设备模式
- (void)configModeWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@optional

/// Device Mode 下拉列表，不实现默认 Standby Mode/Timing Mode/Periodic Mode/Motion Mode
- (NSArray <NSString *>*)deviceModeDataList;

/// 下级设置页入口标题，不实现则不显示入口分组
- (nullable NSArray <NSString *> *)deviceModeSubPageTitles;

/// 下级设置页控制器，顺序与 deviceModeSubPageTitles 一一对应
- (nullable NSArray <UIViewController *> *)deviceModeSubPageViewControllers;

/// 页面标题，不实现默认 Device Mode
- (nullable NSString *)deviceModePageTitle;

@end

NS_ASSUME_NONNULL_END
