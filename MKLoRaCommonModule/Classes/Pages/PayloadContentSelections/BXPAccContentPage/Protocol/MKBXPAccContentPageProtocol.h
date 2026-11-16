
NS_ASSUME_NONNULL_BEGIN

@protocol MKBXPAccContentPageProtocol <NSObject>

@required

@property (nonatomic, assign)BOOL txPower;

@property (nonatomic, assign)BOOL rangingData;

@property (nonatomic, assign)BOOL advInterval;

@property (nonatomic, assign)BOOL sampleRate;

@property (nonatomic, assign)BOOL fullScale;

@property (nonatomic, assign)BOOL motionThreshold;

@property (nonatomic, assign)BOOL axisData;

@property (nonatomic, assign)BOOL battery;

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
