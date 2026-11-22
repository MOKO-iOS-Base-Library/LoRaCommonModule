//
//  MKLoRaSynDataPageProtocol.h
//  MKLoRaCommonModule
//
//  Created by Trae on 2026/11/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 本地数据同步页面图标类型
typedef NS_ENUM(NSInteger, MKLoRaSynDataPageIconType) {
    MKLoRaSynDataPageIconTypeSyncEnable,
    MKLoRaSynDataPageIconTypeSyncDisable,
    MKLoRaSynDataPageIconTypeDeleteEnable,
    MKLoRaSynDataPageIconTypeDeleteDisable,
    MKLoRaSynDataPageIconTypeExportEnable,
    MKLoRaSynDataPageIconTypeExportDisable,
};

/// 本地数据同步页面业务协议。
/// 各产品模块通过实现本协议完成设备通信、数据解析与本地缓存，
/// 公共控制器负责页面交互与展示。
@protocol MKLoRaSynDataPageProtocol <NSObject>

#pragma mark - 设备通信

/// 读取设备指定天数的存储数据
- (void)readNumberOfDaysStoredData:(NSInteger)days
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;

/// 暂停/继续发送本地存储数据
- (void)pauseSendLocalData:(BOOL)pause
                  sucBlock:(void (^)(void))sucBlock
               failedBlock:(void (^)(NSError *error))failedBlock;

/// 清除设备上的所有存储数据
- (void)clearAllDatasWithSucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock;

/// 开始监听设备发送的存储数据，通过 handler 回调原始数据帧
- (void)startReceiveStorageDataWithHandler:(void (^)(NSString *content))handler;

/// 停止监听设备发送的存储数据
- (void)stopReceiveStorageData;

/// 定时通信，防止设备因长时间无通信断开连接
- (void)keepAlive;

#pragma mark - 数据解析

/// 解析汇总数据帧。
/// @return @{@"dataNumber": NSNumber, @"totalSum": NSString}
/// dataNumber 为当前帧携带的数据条数，为 0 时表示最后一帧；
/// totalSum 为设备端存储的总条数。
- (NSDictionary *)parseSynDataSummary:(NSString *)content;

/// 解析一帧数据，返回统一的展示行模型。
/// 时间字段使用以下任意一种：
///   1. @"date": NSString（完整时间字符串）
///   2. @"dateDic": NSDictionary（year/month/day/hour/minute/second）
///   3. @"timestamp": NSString + @"timezone": NSString（时区索引，对应 UTC-12:00 ~ UTC+14:00）
/// 其余字段：@"rawData"（必填）、@"macAddress"、@"rssi"、@"deviceType"
- (NSArray<NSDictionary *> *)parseSynDataContent:(NSString *)content;

#pragma mark - 本地缓存

@optional
/// 读取本地缓存数据，不实现则视为无本地缓存
- (void)readLocalDataWithSucBlock:(void (^)(NSArray<NSDictionary *> *dataList))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock;

/// 清除本地缓存，不实现则视为无本地缓存
- (BOOL)clearLocalData;

/// 保存数据到本地缓存，不实现则视为无本地缓存
- (void)saveLocalDataList:(NSArray<NSDictionary *> *)dataList
                 sucBlock:(void (^)(void))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock;

/// 页面图标，不实现则不显示图标
- (nullable UIImage *)synDataPageIcon:(MKLoRaSynDataPageIconType)type;

#pragma mark - 页面配置

/// 页面标题，不实现时使用默认值 "Local Data Sync"
@property (nonatomic, copy, readonly)NSString *synDataPageTitle;

/// 导出文件名，不实现时使用默认值 "LoRaWAN Data.txt"
@property (nonatomic, copy, readonly)NSString *synDataPageExportFileName;

/// "Time" 输入框缓存 key，不实现则不缓存
@property (nonatomic, copy, readonly)NSString *synDataPageDaysKey;

/// 存储总条数缓存 key，不实现则不缓存
@property (nonatomic, copy, readonly)NSString *synDataPageTotalSumKey;

/// 是否展示 MAC Address，默认 NO
@property (nonatomic, assign, readonly)BOOL synDataPageShowMacAddress;

/// 是否展示 RSSI，默认 NO
@property (nonatomic, assign, readonly)BOOL synDataPageShowRSSI;

/// 是否展示 Device Type，默认 NO
@property (nonatomic, assign, readonly)BOOL synDataPageShowDeviceType;

/// 导出时是否包含 MAC/RSSI，默认 NO
@property (nonatomic, assign, readonly)BOOL synDataPageExportDetail;

/// 点击返回时是否先暂停设备发送并缓存数据，默认 YES
@property (nonatomic, assign, readonly)BOOL synDataPagePauseOnBack;

/// MAC 展示前缀，不实现时使用默认值 "MAC Address:"
@property (nonatomic, copy, readonly)NSString *synDataPageMacTitle;

@end

NS_ASSUME_NONNULL_END
