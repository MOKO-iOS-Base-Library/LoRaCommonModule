//
//  MKLoRaSyncDatabaseManager.h
//  MKLoRaCommonModule
//
//  Created by aa on 2023/7/3.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 同步数据数据库管理
@interface MKLoRaSyncDatabaseManager : NSObject

/// 初始化数据库
/// @param databaseName 数据库名称
/// @param tableName 数据表名称
+ (BOOL)initDataBaseWithDatabaseName:(NSString *)databaseName
                           tableName:(NSString *)tableName;

/// 插入同步数据
/// @param dataList 数据列表
/// @param databaseName 数据库名称
/// @param tableName 数据表名称
/// @param sucBlock 成功回调
/// @param failedBlock 失败回调
+ (void)insertDataList:(NSArray <NSDictionary *>*)dataList
          databaseName:(NSString *)databaseName
             tableName:(NSString *)tableName
              sucBlock:(void (^)(void))sucBlock
           failedBlock:(void (^)(NSError *error))failedBlock;

/// 读取同步数据
/// @param databaseName 数据库名称
/// @param tableName 数据表名称
/// @param sucBlock 成功回调
/// @param failedBlock 失败回调
+ (void)readDataListWithDatabaseName:(NSString *)databaseName
                           tableName:(NSString *)tableName
                            sucBlock:(void (^)(NSArray <NSDictionary *>*dataList))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;

/// 清空数据表
/// @param databaseName 数据库名称
/// @param tableName 数据表名称
+ (BOOL)clearDataTableWithDatabaseName:(NSString *)databaseName
                             tableName:(NSString *)tableName;

@end

NS_ASSUME_NONNULL_END
