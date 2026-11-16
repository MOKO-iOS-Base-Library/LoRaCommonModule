
NS_ASSUME_NONNULL_BEGIN

@protocol MKNanoBeaconContentPageProtocol <NSObject>

@required

@property (nonatomic, assign)BOOL mfgID;

@property (nonatomic, assign)BOOL advType;

@property (nonatomic, assign)BOOL voltage;

@property (nonatomic, assign)BOOL temperature;

@property (nonatomic, assign)BOOL secCnt;

@property (nonatomic, assign)BOOL triggerStatus;

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
