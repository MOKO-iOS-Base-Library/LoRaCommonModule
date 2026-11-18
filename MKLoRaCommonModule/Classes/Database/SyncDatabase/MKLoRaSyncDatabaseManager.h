//
//  MKLoRaSyncDatabaseManager.h
//  MKLoRaCommonModule
//
//  Created by aa on 2023/7/3.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 同步数据数据库管理，各模块通过子类重写 databaseName / tableName 指定自己的库表名
@interface MKLoRaSyncDatabaseManager : NSObject

/// 数据库名称，默认 MKLoRaSyncDB
+ (NSString *)databaseName;

/// 数据表名称，默认 MKLoRaSyncDataTable
+ (NSString *)tableName;

+ (BOOL)initDataBase;

+ (void)insertDataList:(NSArray <NSDictionary *>*)dataList
              sucBlock:(void (^)(void))sucBlock
           failedBlock:(void (^)(NSError *error))failedBlock;

+ (void)readDataListWithSucBlock:(void (^)(NSArray <NSDictionary *>*dataList))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock;

+ (BOOL)clearDataTable;

@end

NS_ASSUME_NONNULL_END
