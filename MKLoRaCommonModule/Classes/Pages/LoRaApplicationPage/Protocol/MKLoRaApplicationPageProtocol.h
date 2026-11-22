#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKLoRaApplicationPageProtocol <NSObject>

/// Time Sync Interval
@property (nonatomic, copy) NSString *timeSyncInterval;

/// Network Interval
@property (nonatomic, copy) NSString *checkInterval;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@optional

/// 是否隐藏 Message Type Settings 行，默认 NO
@property (nonatomic, assign)BOOL hideMessageType;

/// Network Interval 行的标题，不实现时使用默认值
@property (nonatomic, copy)NSString *checkIntervalTitle;

/// Network Interval 行的占位提示，不实现时使用默认值
@property (nonatomic, copy)NSString *checkIntervalPlaceholder;

/// Network Interval 行的单位，不实现时使用默认值
@property (nonatomic, copy)NSString *checkIntervalUnit;

/// Message Type Settings 行点击后的跳转，不实现时不做处理
- (void)pushToMessageTypePageFromController:(UIViewController *)controller;

/// 是否显示 Multicase Group 行，默认 NO，为 YES 时显示在 Message Type Settings 上方
@property (nonatomic, assign)BOOL showMulticaseGroup;

/// Multicase Group 行的标题，不实现时使用默认值
@property (nonatomic, copy)NSString *multicaseGroupTitle;

/// Multicase Group 行点击后的跳转，不实现时不做处理
- (void)pushToMulticaseGroupPageFromController:(UIViewController *)controller;

@end

NS_ASSUME_NONNULL_END
