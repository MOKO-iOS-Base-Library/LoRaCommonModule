//
//  MKLoRaBXPInfoContentPageProtocol.h
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/18.
//

NS_ASSUME_NONNULL_BEGIN

@protocol MKLoRaBXPInfoContentPageProtocol <NSObject>

@required

@property (nonatomic, assign)BOOL txPower;

@property (nonatomic, assign)BOOL rangingData;

@property (nonatomic, assign)BOOL advInterval;

@property (nonatomic, assign)BOOL battery;

@property (nonatomic, assign)BOOL deviceProperty;

@property (nonatomic, assign)BOOL switchStatus;

@property (nonatomic, assign)BOOL firmwareVersion;

@property (nonatomic, assign)BOOL deviceName;

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
