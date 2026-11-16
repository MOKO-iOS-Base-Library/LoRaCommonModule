//
//  MKOutdoorFixPageProtocol.h
//  MKLoRaCommonModule
//
//  Created by aa on 2025.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKOutdoorFixPageProtocol <NSObject>

/// Outdoor BLE Report Interval (Mins)
@property (nonatomic, copy) NSString *bleInterval;

/// Outdoor GPS Report Interval (Mins)
@property (nonatomic, copy) NSString *gpsInterval;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
