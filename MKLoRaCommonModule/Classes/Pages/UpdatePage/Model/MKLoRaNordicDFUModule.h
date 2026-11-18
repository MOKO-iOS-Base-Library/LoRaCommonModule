//
//  MKLoRaNordicDFUModule.h
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/18.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

/// 基于 NordicDFU 的固件升级
@interface MKLoRaNordicDFUModule : NSObject

- (void)updateWithPeripheral:(CBPeripheral *)peripheral
                    filePath:(NSString *)filePath
               progressBlock:(void (^)(CGFloat progress))progressBlock
                    sucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock
         centralDeallocBlock:(void (^)(void))centralDeallocBlock;

@end

NS_ASSUME_NONNULL_END
