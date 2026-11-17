
NS_ASSUME_NONNULL_BEGIN

@protocol MKLoRaMulticaseGroupPageProtocol <NSObject>

@required

@property (nonatomic, assign)BOOL isOn;

@property (nonatomic, copy)NSString *mcAddr;

@property (nonatomic, copy)NSString *mcAppSkey;

@property (nonatomic, copy)NSString *mcNwkSkey;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
