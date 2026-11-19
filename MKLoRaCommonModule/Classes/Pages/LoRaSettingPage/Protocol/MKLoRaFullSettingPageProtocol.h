#import <UIKit/UIKit.h>

#import "Pages/LoRaSettingPage/Protocol/MKLoRaSettingPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MKLoRaFullSettingPageProtocol <MKLoRaSettingPageProtocol>

@property (nonatomic, assign, readonly)BOOL supportClassType;

@property (nonatomic, assign, readonly)BOOL supportMessageType;

@property (nonatomic, assign, readonly)BOOL supportServerPlatform;

@property (nonatomic, assign, readonly)BOOL supportMaxRetransmissionTimes;

@property (nonatomic, assign, readonly)BOOL supportADRACK;

/// 0:非确认帧，1:确认帧
@property (nonatomic, assign)NSInteger messageType;

/// 0:classA，1:classC
@property (nonatomic, assign)NSInteger classType;

/// 0:Third Party NS，1:MOKO IoT DM
@property (nonatomic, assign)NSInteger platform;

/// Gateway ID
@property (nonatomic, copy)NSString *gatewayEUI;

/// 1/2，页面使用从0开始的数据索引
@property (nonatomic, assign)NSInteger transmissions;

/// 0~3
@property (nonatomic, assign)NSInteger retransmission;

@property (nonatomic, copy, readonly)NSString *mokoDevEUI;

@property (nonatomic, copy, readonly)NSString *account;

@property (nonatomic, assign, readonly)BOOL isLoggedIn;

- (NSInteger)currentRegion;

- (NSArray <NSString *>*)RegionList;

- (void)showLoginFromViewController:(UIViewController *)viewController
                         completion:(void (^)(void))completion;

- (void)showLogoutFromViewController:(UIViewController *)viewController
                          completion:(void (^)(void))completion;

- (void)addDeviceToCloudWithSucBlock:(void (^)(void))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;

@optional

/// 是否显示 Transmissions，默认显示
@property (nonatomic, assign, readonly)BOOL supportTransmissions;

/// 确认帧最大重传次数选项，默认 0~3
- (NSArray <NSString *>*)retransmissionValueList;

/// 高级设置说明文案，默认使用全功能设置页文案
- (NSString *)CHNoteMsg;
- (NSString *)dutyCycleNoteMsg;
- (NSString *)DRForJoinNoteMsg;

/// 当前设备是否支持 EU868 单通道，页面仅在 EU868 Region 下显示
@property (nonatomic, assign, readonly)BOOL supportEU868SingleChannel;

@property (nonatomic, assign)BOOL eu868SignleChannelStatus;

/// 0: 868.1MHz 1:868.3MHz 2:868.5MHz
@property (nonatomic, assign)NSInteger eu868SignleChannel;

@end

NS_ASSUME_NONNULL_END
