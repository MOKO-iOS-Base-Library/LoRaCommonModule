
NS_ASSUME_NONNULL_BEGIN

@protocol MKLoRaURLContentPageProtocol <NSObject>

@required

/// RSSI@0M
@property (nonatomic, assign)BOOL measured;

@property (nonatomic, assign)BOOL url;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@optional

@property (nonatomic, assign)BOOL macAddress;

@property (nonatomic, assign)BOOL rssi;

@property (nonatomic, assign)BOOL timestamp;

@property (nonatomic, assign)BOOL advertising;

@property (nonatomic, assign)BOOL response;

@end

NS_ASSUME_NONNULL_END
