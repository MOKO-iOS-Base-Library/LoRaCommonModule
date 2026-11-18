//
//  MKLoRaLogDatabaseManager.h
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/18.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 设备日志数据库管理
@interface MKLoRaLogDatabaseManager : NSObject

/// 插入设备日志
/// @param logList 日志列表
/// @param macAddress 设备的mac地址，作为数据库前缀名字区分不同设备
/// @param databaseName 数据库名称
/// @param tableName 日志表名称
/// @param sucBlock 成功回调
/// @param failedBlock 失败回调
+ (void)insertLogDatas:(NSArray <NSDictionary *>*)logList
            macAddress:(NSString *)macAddress
          databaseName:(NSString *)databaseName
             tableName:(NSString *)tableName
              sucBlock:(void (^)(void))sucBlock
           failedBlock:(void (^)(NSError *error))failedBlock;

/// 读取本地日志
/// @param macAddress 设备的mac地址
/// @param databaseName 数据库名称
/// @param tableName 日志表名称
/// @param sucBlock 成功回调
/// @param failedBlock 失败回调
+ (void)readLocalLogsWithMacAddress:(NSString *)macAddress
                       databaseName:(NSString *)databaseName
                          tableName:(NSString *)tableName
                           sucBlock:(void (^)(NSArray <NSDictionary *>*logList))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

/// 删除本地日志
/// @param macAddress 设备的mac地址
/// @param databaseName 数据库名称
/// @param tableName 日志表名称
/// @param sucBlock 成功回调
/// @param failedBlock 失败回调
+ (void)deleteDatasWithMacAddress:(NSString *)macAddress
                     databaseName:(NSString *)databaseName
                        tableName:(NSString *)tableName
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
