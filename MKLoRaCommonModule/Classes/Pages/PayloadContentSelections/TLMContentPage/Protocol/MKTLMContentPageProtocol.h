
NS_ASSUME_NONNULL_BEGIN

@protocol MKTLMContentPageProtocol <NSObject>

@required

@property (nonatomic, assign)BOOL version;

@property (nonatomic, assign)BOOL battery;

@property (nonatomic, assign)BOOL temperature;

@property (nonatomic, assign)BOOL ADV_CNT;

@property (nonatomic, assign)BOOL SEC_CNT;

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
