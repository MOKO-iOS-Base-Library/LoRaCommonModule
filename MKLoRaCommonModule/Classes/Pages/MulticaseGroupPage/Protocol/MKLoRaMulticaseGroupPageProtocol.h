#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKLoRaMulticaseGroupPageProtocol <NSObject>

@required

@property (nonatomic, assign)BOOL isOn;

@property (nonatomic, copy)NSString *mcAddr;

@property (nonatomic, copy)NSString *mcAppSkey;

@property (nonatomic, copy)NSString *mcNwkSkey;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@optional

/// 页面标题，同时作为开关行文案，不实现默认 Multicase Group
- (nullable NSString *)multicaseGroupPageTitle;

/// 开关行文案字体，不实现使用默认字体
- (nullable UIFont *)multicaseGroupPageSwitchMsgFont;

/// 开关行文案颜色，不实现使用默认颜色
- (nullable UIColor *)multicaseGroupPageSwitchMsgColor;

/// 保存按钮图标，不实现使用基础组件默认图标
- (nullable UIImage *)multicaseGroupPageSaveIcon;

/// 保存成功提示文案，不实现默认 Success
- (nullable NSString *)multicaseGroupPageSuccessMsg;

@end

NS_ASSUME_NONNULL_END
