
NS_ASSUME_NONNULL_BEGIN

@protocol MKLoRaSettingPageProtocol <NSObject>

//1:ABP,2:OTAA
@property (nonatomic, assign)NSInteger modem;

//OTAA模式/ABP模式
@property (nonatomic, copy)NSString *devEUI;

//OTAA模式/ABP模式
@property (nonatomic, copy)NSString *appEUI;

//OTAA模式
@property (nonatomic, copy)NSString *appKey;

//OTAA模式/ABP模式
@property (nonatomic, copy)NSString *devAddr;

//OTAA模式/ABP模式
@property (nonatomic, copy)NSString *nwkSKey;

//OTAA模式/ABP模式
@property (nonatomic, copy)NSString *appSKey;

/**
 0:AS923
 1:AU915
 2:CN470
 3:CN779
 4:EU433
 5:EU868
 6:KR920
 7:IN865
 8:US915
 9:RU864
 10:AS923-1
 11:AS923-2
 12:AS923-3
 13:AS923-4
 */
@property (nonatomic, assign)NSInteger region;

/// 底部是否需要高级选项
@property (nonatomic, assign)BOOL needAdvanceSetting;

/// 底部高级选项是否打开(needAdvanceSetting == YES情况下)
@property (nonatomic, assign)BOOL advancedStatus;

/// 当频段选择为US915、AU915和CN470时，CH设置项显示。
@property (nonatomic, assign)NSInteger CHL;

/// 当频段选择为US915、AU915和CN470时，CH设置项显示。
@property (nonatomic, assign)NSInteger CHH;

//CN779, EU433, EU868, RU864
@property (nonatomic, assign)BOOL dutyIsOn;

@optional

/// It is only used for CN470, CN779, EU433, EU868, KR920, IN865, RU864, AS923-1~4
/// 0~15
@property (nonatomic, assign)NSInteger join;

@required

@property (nonatomic, assign)BOOL adrIsOn;

@optional

@property (nonatomic, assign)NSInteger DRL;

@property (nonatomic, assign)NSInteger DRH;

/// 1~255
@property (nonatomic, copy)NSString *ackLimit;

/// 1~255
@property (nonatomic, copy)NSString *ackDelay;

@required

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

/// 用户主动选择了region，底部高级设置需要按照需求设置为默认值
- (void)configAdvanceSettingDefaultParams;

- (NSArray <NSString *>*)CHLValueList;
- (NSArray <NSString *>*)CHHValueList;
- (NSArray <NSString *>*)DRValueList;

@optional

/// 标准 region 值（0~13，含义同 region），用于判断设置项是否显示。
/// 默认等于 region；使用简化 region 值的产品需要实现该映射。
- (NSInteger)canonicalRegion;

/// Model 提供自定义的 Region 列表（用于通用 region 值产品）
- (NSArray <NSString *>*)RegionList;

- (NSArray <NSString *>*)DRLValueList;
- (NSArray <NSString *>*)DRHValueList;

@end

NS_ASSUME_NONNULL_END
