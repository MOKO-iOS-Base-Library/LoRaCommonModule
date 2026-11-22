//
//  MKLoRaScanReportPageProtocol.h
//  MKLoRaCommonModule_Example
//
//  Created by aa on 2026/11/18.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//


NS_ASSUME_NONNULL_BEGIN

@protocol MKLoRaScanReportPageProtocol <NSObject>

/*
 0:No Scan & No report
 1:Timing scan & Immediately report
 2:Periodic scan & Immediately report
 3:Scan always on & Periodic report
 4:Periodic scan & Periodic report
 5:Scan always on & Timing report
 6:Timing scan & Timing report
 7:Periodic scan & Timing report
 */
@property (nonatomic, assign)NSInteger strategy;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@optional
/**
 提供各扫描策略子页面的业务Model，不实现或返回nil时子页面不注入protocol（保持旧行为）
 @param row 子页面在列表中的行号，0:Timing Scan & Immediately Report，1:Periodic Scan & Immediately Report，
 2:Scan Always On & Periodic Report，3:Periodic Scan & Periodic Report，4:Scan Always On & Timing Report，
 5:Timing Scan & Timing Report，6:Periodic Scan & Timing Report
 */
- (nullable id)scanReportPageChildProtocolWithRow:(NSInteger)row;

@end

NS_ASSUME_NONNULL_END
