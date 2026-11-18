#import <UIKit/UIKit.h>

#import "Pages/LoRaSettingPage/Protocol/MKLoRaSettingPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MKLoRaFullSettingPageProtocol <MKLoRaSettingPageProtocol>

@property (nonatomic, assign, readonly)BOOL supportClassType;

@property (nonatomic, assign, readonly)BOOL supportMessageType;

@property (nonatomic, assign, readonly)BOOL supportServerPlatform;

@property (nonatomic, assign, readonly)BOOL supportMaxRetransmissionTimes;

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

@end

NS_ASSUME_NONNULL_END
