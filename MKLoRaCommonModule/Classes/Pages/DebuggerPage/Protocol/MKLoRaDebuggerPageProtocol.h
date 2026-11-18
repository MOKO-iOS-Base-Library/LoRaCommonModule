
NS_ASSUME_NONNULL_BEGIN

@protocol MKLoRaDebuggerPageProtocol <NSObject>

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

/// 进入 Debugger 模式时需要发送的模块通知名（可选，用于 TabBar 等）
- (NSString *)debuggerModeStartNotificationName;

/// 退出 Debugger 模式时需要发送的模块通知名（可选）
- (NSString *)debuggerModeStopNotificationName;

/// 设备断开连接时需要发送的返回根页面通知名（可选）
- (NSString *)popToRootViewControllerNotificationName;

/// 模块自身的设备连接状态改变通知名（可选）
- (NSString *)peripheralConnectStateChangedNotificationName;

@end

NS_ASSUME_NONNULL_END
