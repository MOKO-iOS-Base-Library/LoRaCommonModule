
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKLoRaPageProtocol <NSObject>

@property (nonatomic, copy) NSString *modem;

@property (nonatomic, copy) NSString *region;

@property (nonatomic, copy) NSString *classType;

/// 网络连接状态
@property (nonatomic, copy) NSString *networkStatus;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@optional

/// 子组件实现：点击 Connection Settings 时的跳转
- (void)pushToLoRaSettingPageFromController:(UIViewController *)controller;

/// 子组件实现：点击 Application Settings 时的跳转
- (void)pushToLoRaApplicationPageFromController:(UIViewController *)controller;

/// 子组件实现左上角返回按钮行为，返回 YES 表示已处理
- (BOOL)loraPageHandleLeftButtonTapFromController:(UIViewController *)controller;

@end

NS_ASSUME_NONNULL_END
