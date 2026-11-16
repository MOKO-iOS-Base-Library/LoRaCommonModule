
NS_ASSUME_NONNULL_BEGIN

@protocol MKAboutPageProtocol <NSObject>

/// 应用名称（如 "MT001"、"LW003 Plus"）
@property (nonatomic, copy) NSString *appName;

/// 固件版本（如 "FW Version:V1.0"、"FW Version:1.0"）
@property (nonatomic, copy) NSString *firmwareLabel;

@end

NS_ASSUME_NONNULL_END
