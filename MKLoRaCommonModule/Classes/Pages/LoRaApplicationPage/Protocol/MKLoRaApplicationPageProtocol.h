
NS_ASSUME_NONNULL_BEGIN

@protocol MKLoRaApplicationPageProtocol <NSObject>

/// Time Sync Interval
@property (nonatomic, copy) NSString *timeSyncInterval;

/// Network Interval
@property (nonatomic, copy) NSString *checkInterval;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
