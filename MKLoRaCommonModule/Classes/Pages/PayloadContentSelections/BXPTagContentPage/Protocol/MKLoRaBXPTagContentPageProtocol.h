//
//  MKLoRaBXPTagContentPageProtocol.h
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/18.
//

NS_ASSUME_NONNULL_BEGIN

@protocol MKLoRaBXPTagContentPageProtocol <NSObject>

@required

@property (nonatomic, assign)BOOL sensorStatus;

@property (nonatomic, assign)BOOL hallCount;

@property (nonatomic, assign)BOOL motionCount;

@property (nonatomic, assign)BOOL axisData;

@property (nonatomic, assign)BOOL battery;

@property (nonatomic, assign)BOOL tagID;

@property (nonatomic, assign)BOOL deviceName;

@property (nonatomic, assign)BOOL temperature;

@property (nonatomic, assign)BOOL humidity;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@optional

- (BOOL)contentPageShowExtendedFields;

@property (nonatomic, assign)BOOL macAddress;

@property (nonatomic, assign)BOOL rssi;

@property (nonatomic, assign)BOOL timestamp;

@property (nonatomic, assign)BOOL advertising;

@property (nonatomic, assign)BOOL response;

@end

NS_ASSUME_NONNULL_END
