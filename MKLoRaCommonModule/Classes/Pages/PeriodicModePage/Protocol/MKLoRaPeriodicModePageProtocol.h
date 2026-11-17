
#import "Common/Protocol/MKLoRaDeviceModePageBaseProtocol.h"

@protocol MKLoRaPeriodicModePageProtocol <MKLoRaDeviceModePageBaseProtocol>

/*
 0:BLE
 1:GPS
 2:BLE+GPS
 3:BLE*GPS
 4:BLE&GPS
 */
@property (nonatomic, assign)NSInteger strategy;

@property (nonatomic, copy)NSString *interval;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@optional

/// Positioning Strategy 下拉列表，不实现时使用默认列表
@property (nonatomic, copy)NSArray<NSString *> *strategyDataList;

/// 是否隐藏 Positioning Strategy 行，默认 NO
@property (nonatomic, assign)BOOL hideStrategy;

/// Report Interval 占位提示，不实现时使用默认值
@property (nonatomic, copy)NSString *intervalPlaceholder;

/// Report Interval 单位，不实现时使用默认值
@property (nonatomic, copy)NSString *intervalUnit;

/// 页面标题，不实现时使用默认值
@property (nonatomic, copy)NSString *pageTitle;

@end
