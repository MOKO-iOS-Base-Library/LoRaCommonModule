
NS_ASSUME_NONNULL_BEGIN

@protocol MKLCGpsFixPageProtocol <NSObject>

/// Positioning Timeout
@property (nonatomic, copy) NSString *timeout;

/// PDOP
@property (nonatomic, copy) NSString *pdop;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
