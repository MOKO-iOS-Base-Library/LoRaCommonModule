//
//  MKLoRaOtherTypeContentPageProtocol.h
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/18.
//

NS_ASSUME_NONNULL_BEGIN

/// 数据块过滤选项 Model（Protocol 层暴露，供 Controller 使用）
@protocol MKLoRaOtherBlockOptionModelProtocol <NSObject>

@property (nonatomic, copy)NSString *dataType;

@property (nonatomic, assign)NSInteger minIndex;

@property (nonatomic, assign)NSInteger maxIndex;

- (BOOL)validParams;

@end

@protocol MKLoRaOtherTypeContentPageProtocol <NSObject>

@required

@property (nonatomic, strong)NSMutableArray *blockList;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configBlockOptionList:(NSArray *)list
                     sucBlock:(void (^)(void))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock;

@optional

- (BOOL)contentPageShowExtendedFields;

@property (nonatomic, assign)BOOL macAddress;

@property (nonatomic, assign)BOOL rssi;

@property (nonatomic, assign)BOOL timestamp;

@property (nonatomic, assign)BOOL advertising;

@property (nonatomic, assign)BOOL response;

@end

NS_ASSUME_NONNULL_END
