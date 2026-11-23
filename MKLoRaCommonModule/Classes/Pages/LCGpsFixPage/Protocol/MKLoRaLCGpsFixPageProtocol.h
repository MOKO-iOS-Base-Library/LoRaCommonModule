
NS_ASSUME_NONNULL_BEGIN

@protocol MKLoRaLCGpsFixPageProtocol <NSObject>

/// Positioning Timeout
@property (nonatomic, copy) NSString *timeout;

/// PDOP
@property (nonatomic, copy) NSString *pdop;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@optional

/// Extra Positioning Duration，实现该属性才会显示对应的输入项
@property (nonatomic, copy) NSString *duration;

/// Extra Positioning Duration 的输入范围提示，默认 "30 ~ 600"
@property (nonatomic, copy) NSString *durationRangeText;

@end

NS_ASSUME_NONNULL_END
