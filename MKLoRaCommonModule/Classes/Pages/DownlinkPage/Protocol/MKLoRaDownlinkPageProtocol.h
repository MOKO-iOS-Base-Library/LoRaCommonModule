
NS_ASSUME_NONNULL_BEGIN

@protocol MKLoRaDownlinkPageProtocol <NSObject>

/// Positioning Strategy
@property (nonatomic, assign) NSInteger positioningStrategy;

/// 可选：Positioning Strategy 下拉列表（默认 @[@"BLE",@"GPS",@"BLE+GPS",@"BLE*GPS"]）
@optional
@property (nonatomic, copy) NSArray<NSString *> *strategyDataList;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
