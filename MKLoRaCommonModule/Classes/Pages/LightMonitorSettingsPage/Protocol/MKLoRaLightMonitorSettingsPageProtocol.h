//
//  MKLoRaLightMonitorSettingsPageProtocol.h
//  MKLoRaCommonModule
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKLoRaLightMonitorSettingsPageProtocol <NSObject>

@property (nonatomic, assign)BOOL isOn;

@property (nonatomic, copy)NSString *sampleRate;

/// 当前光照强度，只读展示
@property (nonatomic, copy)NSString *intensity;

@property (nonatomic, assign)BOOL alarmSwitch;

@property (nonatomic, copy)NSString *lightThreshold;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@optional

/// Sample Rate 输入范围提示，默认 "1~3600"
@property (nonatomic, copy)NSString *sampleRateRangeText;

/// Light Threshold 输入范围提示，默认 "10~200"
@property (nonatomic, copy)NSString *lightThresholdRangeText;

@end

NS_ASSUME_NONNULL_END
