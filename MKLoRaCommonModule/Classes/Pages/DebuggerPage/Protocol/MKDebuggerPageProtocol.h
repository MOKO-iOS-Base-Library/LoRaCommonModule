
NS_ASSUME_NONNULL_BEGIN

@protocol MKDebuggerPageProtocol <NSObject>

/// 设备 MAC 地址（日志的唯一标识）
@property (nonatomic, copy, readonly) NSString *macAddress;

/// 当前设备是否已连接
@property (nonatomic, assign, readonly) BOOL isDeviceConnected;

/// 从本地读取日志数据
- (void)fetchLogDataWithSucBlock:(void (^)(NSArray<NSDictionary *> *logList))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock;

/// 删除所有日志（按 macAddress 维度）
- (void)deleteAllLogsWithSucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock;

/// 将日志列表保存到本地
- (void)insertLogDatas:(NSArray<NSDictionary *> *)logList
            macAddress:(NSString *)macAddress
             sucBlock:(void (^)(void))sucBlock
          failedBlock:(void (^)(NSError *error))failedBlock;

/// 开始 Debugger 模式，持续通过 logBlock 回调推送日志
- (void)startDebuggerModeWithLogBlock:(void (^)(NSString *log))logBlock;

/// 停止 Debugger 模式
- (void)stopDebuggerMode;

/// 当前固件版本标签（可选）
@optional
- (NSString *)currentFirmwareLabel;

@end

NS_ASSUME_NONNULL_END
