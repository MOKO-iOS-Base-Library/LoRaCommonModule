
NS_ASSUME_NONNULL_BEGIN

@protocol MKLoRaBXPButtonContentPageProtocol <NSObject>

@required

@property (nonatomic, assign)BOOL frameType;

@property (nonatomic, assign)BOOL statusFlag;

@property (nonatomic, assign)BOOL triggerCount;

@property (nonatomic, assign)BOOL deviceID;

@property (nonatomic, assign)BOOL firmwareType;

@property (nonatomic, assign)BOOL deviceName;

@property (nonatomic, assign)BOOL fullScale;

@property (nonatomic, assign)BOOL motionThreshold;

@property (nonatomic, assign)BOOL axisData;

@property (nonatomic, assign)BOOL temperature;

@property (nonatomic, assign)BOOL rangingData;

@property (nonatomic, assign)BOOL battery;

@property (nonatomic, assign)BOOL txPower;

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
