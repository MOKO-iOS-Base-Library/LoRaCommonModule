
NS_ASSUME_NONNULL_BEGIN

@protocol MKLoRaPageProtocol <NSObject>

@property (nonatomic, copy) NSString *modem;

@property (nonatomic, copy) NSString *region;

@property (nonatomic, copy) NSString *classType;

/// 网络连接状态
@property (nonatomic, copy) NSString *networkStatus;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
