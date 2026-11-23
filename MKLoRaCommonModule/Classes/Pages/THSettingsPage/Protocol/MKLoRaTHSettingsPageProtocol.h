//
//  MKLoRaTHSettingsPageProtocol.h
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKLoRaTHSettingsPageProtocol <NSObject>

#pragma mark - required

@property (nonatomic, assign) BOOL functionSwitch;

@property (nonatomic, copy) NSString *sampleRate;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock
                   failedBlock:(void (^)(NSError *error))failedBlock;

@optional

#pragma mark - 温湿度读数（部分设备支持）

@property (nonatomic, assign) BOOL hasTemperature;

@property (nonatomic, copy) NSString *temperature;

@property (nonatomic, assign) BOOL hasHumidity;

@property (nonatomic, copy) NSString *humidity;

#pragma mark - 文案

/// 采样率输入框占位文案，默认“1~10”
- (NSString *)thSettingsPageSampleRatePlaceholder;

/// 页面标题，默认“T&H Settings”
- (NSString *)thSettingsPageTitle;

@end

NS_ASSUME_NONNULL_END
