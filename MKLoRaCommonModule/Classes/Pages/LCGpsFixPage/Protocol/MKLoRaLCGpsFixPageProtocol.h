
NS_ASSUME_NONNULL_BEGIN

@protocol MKLoRaLCGpsFixPageProtocol <NSObject>

/// Positioning Timeout
@property (nonatomic, copy) NSString *timeout;

/// PDOP
@property (nonatomic, copy) NSString *pdop;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@optional

/// PDOP 的输入范围提示，默认 "5 ~ 100"
@property (nonatomic, copy) NSString *pdopRangeText;

/// Positioning Timeout 的输入范围提示，默认 "30 ~ 600"
@property (nonatomic, copy) NSString *timeoutRangeText;

/// Extra Positioning Duration，实现该属性才会显示对应的输入项
@property (nonatomic, copy) NSString *duration;

/// Extra Positioning Duration 的输入范围提示，默认 "30 ~ 600"
@property (nonatomic, copy) NSString *durationRangeText;

/// Extrme Mode 开关，实现该属性才会显示对应的开关分组
@property (nonatomic, assign) BOOL extrmeMode;

/// Extrme Mode 开关文案，默认 "Extrme Mode"
@property (nonatomic, copy) NSString *extrmeModeTitle;

@end

NS_ASSUME_NONNULL_END
