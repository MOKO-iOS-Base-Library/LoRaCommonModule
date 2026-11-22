
#import <UIKit/UIKit.h>

#import "Common/Protocol/MKLoRaDeviceModePageBaseProtocol.h"

@protocol MKLoRaMotionModePageProtocol <MKLoRaDeviceModePageBaseProtocol>

@property (nonatomic, assign)BOOL fixOnStart;

@property (nonatomic, copy)NSString *numberOfFixOnStart;

/// Positioning Strategy，索引对应 posStrategyDataList 中的可选项
@property (nonatomic, assign)NSInteger posStrategyOnStart;

@property (nonatomic, assign)BOOL fixInTrip;

@property (nonatomic, copy)NSString *reportIntervalInTrip;

/// Positioning Strategy，索引对应 posStrategyInTripDataList 中的可选项
@property (nonatomic, assign)NSInteger posStrategyInTrip;

@property (nonatomic, assign)BOOL fixOnEnd;

@property (nonatomic, copy)NSString *tripEndTimeout;

@property (nonatomic, copy)NSString *numberOfFixOnEnd;

@property (nonatomic, copy)NSString *reportIntervalOnEnd;

/// Positioning Strategy，索引对应 posStrategyDataList 中的可选项
@property (nonatomic, assign)NSInteger posStrategyOnEnd;

@property (nonatomic, assign)BOOL fixOnStationary;

@property (nonatomic, copy)NSString *reportIntervalOnStationary;

/// Positioning Strategy，索引对应 posStrategyDataList 中的可选项
@property (nonatomic, assign)NSInteger posStrategyOnStationary;

@property (nonatomic, assign)BOOL notifyEventOnStart;

@property (nonatomic, assign)BOOL notifyEventInTrip;

@property (nonatomic, assign)BOOL notifyEventOnEnd;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@optional

/// On Start / On End / On Stationary 的 Positioning Strategy 下拉列表，不实现时使用默认列表
@property (nonatomic, copy)NSArray<NSString *> *posStrategyDataList;

/// In Trip 的 Positioning Strategy 下拉列表，不实现时使用默认列表
@property (nonatomic, copy)NSArray<NSString *> *posStrategyInTripDataList;

/// 页面标题，不实现时使用默认值
@property (nonatomic, copy)NSString *pageTitle;

/// 是否隐藏 "Number Of Fix On Start" 行，默认 NO
@property (nonatomic, assign)BOOL hideFixCountOnStart;

/// 是否隐藏 Stationary 相关配置，默认 NO
@property (nonatomic, assign)BOOL hideStationary;

/// 是否隐藏所有 Positioning Strategy 行，默认 NO
@property (nonatomic, assign)BOOL hideStrategy;

/// Number Of Fix On Start 占位提示，不实现时使用默认值
@property (nonatomic, copy)NSString *fixCountOnStartPlaceholder;

/// Trip End Timeout 占位提示，不实现时使用默认值
@property (nonatomic, copy)NSString *tripEndTimeoutPlaceholder;

/// Number Of Fix On End 占位提示，不实现时使用默认值
@property (nonatomic, copy)NSString *numberOfFixOnEndPlaceholder;

/// 保存按钮图标，不实现使用基础组件默认图标
- (nullable UIImage *)motionModePageSaveIcon;

/// 导航标题字体，不实现使用基础组件默认字体
- (nullable UIFont *)motionModePageNavTitleFont;

@end
