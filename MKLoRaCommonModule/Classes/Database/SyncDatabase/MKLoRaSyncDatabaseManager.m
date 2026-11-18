//
//  MKLoRaSyncDatabaseManager.m
//  MKLoRaCommonModule
//
//  Created by aa on 2023/7/3.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKLoRaSyncDatabaseManager.h"

#import "FMDB.h"

#import "MKMacroDefines.h"

@implementation MKLoRaSyncDatabaseManager

+ (BOOL)initDataBaseWithDatabaseName:(NSString *)databaseName
                           tableName:(NSString *)tableName {
    FMDatabase* db = [FMDatabase databaseWithPath:kFilePath(databaseName)];
    if (![db open]) {
        return NO;
    }
    NSString *sqlCreateTable = [NSString stringWithFormat:@"create table if not exists %@ (date text,rawData text)", tableName];
    BOOL resCreate = [db executeUpdate:sqlCreateTable];
    if (!resCreate) {
        [db close];
        return NO;
    }
    return YES;
}

+ (void)insertDataList:(NSArray <NSDictionary *>*)dataList
          databaseName:(NSString *)databaseName
             tableName:(NSString *)tableName
              sucBlock:(void (^)(void))sucBlock
           failedBlock:(void (^)(NSError *error))failedBlock {
    if (!dataList) {
        [self operationInsertFailedBlock:failedBlock];
        return ;
    }
    NSString *dbPath = kFilePath(databaseName);
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        [self operationInsertFailedBlock:failedBlock];
        return;
    }
    NSString *sqlCreateTable = [NSString stringWithFormat:@"create table if not exists %@ (date text,rawData text)", tableName];
    BOOL resCreate = [db executeUpdate:sqlCreateTable];
    if (!resCreate) {
        [db close];
        [self operationInsertFailedBlock:failedBlock];
        return;
    }
    [[FMDatabaseQueue databaseQueueWithPath:dbPath] inDatabase:^(FMDatabase *db) {
        for (NSDictionary *dic in dataList) {
            [db executeUpdate:[NSString stringWithFormat:@"INSERT INTO %@ (date, rawData) VALUES (?,?)", tableName], SafeStr(dic[@"date"]), SafeStr(dic[@"rawData"])];
        }
        if (sucBlock) {
            moko_dispatch_main_safe(^{
                sucBlock();
            });
        }
        [db close];
    }];
}

+ (void)readDataListWithDatabaseName:(NSString *)databaseName
                           tableName:(NSString *)tableName
                            sucBlock:(void (^)(NSArray <NSDictionary *>*dataList))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *dbPath = kFilePath(databaseName);
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        [self operationGetDataFailedBlock:failedBlock];
        return;
    }
    [[FMDatabaseQueue databaseQueueWithPath:dbPath] inDatabase:^(FMDatabase *db) {
        NSMutableArray *tempDataList = [NSMutableArray array];
        FMResultSet * result = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@", tableName]];
        while ([result next]) {
            NSDictionary *resultDic = @{
                @"date":[result stringForColumn:@"date"],
                @"rawData":[result stringForColumn:@"rawData"],
            };
            [tempDataList addObject:resultDic];
        }
        if (sucBlock) {
            moko_dispatch_main_safe(^{
                sucBlock(tempDataList);
            });
        }
        [db close];
    }];
}

+ (BOOL)clearDataTableWithDatabaseName:(NSString *)databaseName
                             tableName:(NSString *)tableName {
    FMDatabase* db = [FMDatabase databaseWithPath:kFilePath(databaseName)];
    if ([db open]) {
        BOOL success = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@", tableName]];
        [db close];
        return success;
    }
    return NO;
}

+ (void)operationFailedBlock:(void (^)(NSError *error))block msg:(NSString *)msg{
    if (block) {
        NSError *error = [[NSError alloc] initWithDomain:@"com.moko.databaseOperation"
                                                    code:-111111
                                                userInfo:@{@"errorInfo":msg}];
        moko_dispatch_main_safe(^{
            block(error);
        });
    }
}

+ (void)operationInsertFailedBlock:(void (^)(NSError *error))block{
    [self operationFailedBlock:block msg:@"insert data error"];
}

+ (void)operationUpdateFailedBlock:(void (^)(NSError *error))block{
    [self operationFailedBlock:block msg:@"update data error"];
}

+ (void)operationDeleteFailedBlock:(void (^)(NSError *error))block{
    [self operationFailedBlock:block msg:@"fail to delete"];
}

+ (void)operationGetDataFailedBlock:(void (^)(NSError *error))block{
    [self operationFailedBlock:block msg:@"get data error"];
}

@end
