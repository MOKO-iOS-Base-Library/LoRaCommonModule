
#import "Common/Protocol/MKLoRaDeviceModePageBaseProtocol.h"

@protocol MKLoRaStandbyModePageProtocol <MKLoRaDeviceModePageBaseProtocol>

/// Positioning Strategy，索引对应 strategyDataList 中的可选项
@property (nonatomic, assign)NSInteger strategy;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@optional

/// Positioning Strategy 下拉列表，不实现时使用默认列表
@property (nonatomic, copy)NSArray<NSString *> *strategyDataList;

@end
