
#import "Pages/TimingModePage/Model/MKLoRaTimingModeTimePointModel.h"
#import "Common/Protocol/MKLoRaDeviceModePageBaseProtocol.h"

@protocol MKLoRaTimingModePageProtocol <MKLoRaDeviceModePageBaseProtocol>

/// 最大可以添加的时间点个数，默认10
@property (nonatomic, assign)NSInteger maxPointList;

/*
 0:BLE
 1:GPS
 2:BLE+GPS
 3:BLE*GPS
 */
@property (nonatomic, assign)NSInteger strategy;

@property (nonatomic, strong)NSArray <MKLoRaTimingModeTimePointModel *>*pointList;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configData:(NSArray <MKLoRaTimingModeTimePointModel *>*)pointList
          sucBlock:(void (^)(void))sucBlock
       failedBlock:(void (^)(NSError *error))failedBlock;

@optional

/// Positioning Strategy 下拉列表，不实现时使用默认列表
@property (nonatomic, copy)NSArray<NSString *> *strategyDataList;

/// 是否隐藏 Positioning Strategy 行，默认 NO
@property (nonatomic, assign)BOOL hideStrategy;

/// 页面标题，不实现时使用默认值
@property (nonatomic, copy)NSString *pageTitle;

@end
