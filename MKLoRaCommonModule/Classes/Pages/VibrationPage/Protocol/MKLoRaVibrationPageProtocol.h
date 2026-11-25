
NS_ASSUME_NONNULL_BEGIN

@protocol MKLoRaVibrationPageProtocol <NSObject>

/// Shock Detection 开关
@property (nonatomic, assign) BOOL isOn;

/// Report Interval
@property (nonatomic, copy) NSString *reportInterval;

/// Shock Timeout
@property (nonatomic, copy) NSString *vibrationTimeout;

/// Shock Thresholds
@property (nonatomic, copy) NSString *vibrationThresholds;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@optional

/// 是否隐藏 Shock Thresholds 输入项，默认 NO（显示）
@property (nonatomic, assign) BOOL hideShockThresholds;

/// Shock 文本输入项的展示顺序，数组元素取值 0/1/2，分别对应
/// Report Interval、Shock Timeout、Shock Thresholds；
/// 不实现时按默认顺序展示
@property (nonatomic, copy) NSArray <NSNumber *> *textFieldOrder;

@end

NS_ASSUME_NONNULL_END
