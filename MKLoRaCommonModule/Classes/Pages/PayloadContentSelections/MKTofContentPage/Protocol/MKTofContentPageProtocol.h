
NS_ASSUME_NONNULL_BEGIN

@protocol MKTofContentPageProtocol <NSObject>

@required

@property (nonatomic, assign)BOOL macAddress;

@property (nonatomic, assign)BOOL rssi;

@property (nonatomic, assign)BOOL timestamp;

@property (nonatomic, assign)BOOL mfg;

@property (nonatomic, assign)BOOL beacon;

@property (nonatomic, assign)BOOL battery;

@property (nonatomic, assign)BOOL ranging;

@property (nonatomic, assign)BOOL user;

@property (nonatomic, assign)BOOL subType;

@property (nonatomic, assign)BOOL deviceName;

@property (nonatomic, assign)BOOL advertising;

@property (nonatomic, assign)BOOL response;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
