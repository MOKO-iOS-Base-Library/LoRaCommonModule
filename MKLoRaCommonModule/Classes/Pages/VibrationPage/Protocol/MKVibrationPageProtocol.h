
NS_ASSUME_NONNULL_BEGIN

@protocol MKVibrationPageProtocol <NSObject>

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

@end

NS_ASSUME_NONNULL_END
