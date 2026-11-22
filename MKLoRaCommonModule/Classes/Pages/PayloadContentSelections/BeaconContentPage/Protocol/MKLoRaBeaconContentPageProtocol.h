//
//  MKLoRaBeaconContentPageProtocol.h
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/18.
//

NS_ASSUME_NONNULL_BEGIN

@protocol MKLoRaBeaconContentPageProtocol <NSObject>

@required

@property (nonatomic, assign)BOOL uuid;

@property (nonatomic, assign)BOOL major;

@property (nonatomic, assign)BOOL minor;

/// Measured RSSI@1M
@property (nonatomic, assign)BOOL measured;

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
