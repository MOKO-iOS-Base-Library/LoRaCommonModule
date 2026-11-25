//
//  MKLoRaSyncDatabaseManager.m
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/18.
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
    NSString *sqlCreateTable = [NSString stringWithFormat:@"create table if not exists %@ (date text,rawData text,record text)", tableName];
    BOOL resCreate = [db executeUpdate:sqlCreateTable];
    if (!resCreate) {
        [db close];
        return NO;
    }
    [self ensureRecordColumnForTable:tableName db:db];
    [db close];
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
    NSString *sqlCreateTable = [NSString stringWithFormat:@"create table if not exists %@ (date text,rawData text,record text)", tableName];
    BOOL resCreate = [db executeUpdate:sqlCreateTable];
    if (!resCreate) {
        [db close];
        [self operationInsertFailedBlock:failedBlock];
        return;
    }
    [[FMDatabaseQueue databaseQueueWithPath:dbPath] inDatabase:^(FMDatabase *db) {
        [self ensureRecordColumnForTable:tableName db:db];
        for (NSDictionary *dic in dataList) {
            [db executeUpdate:[NSString stringWithFormat:@"INSERT INTO %@ (date, rawData, record) VALUES (?,?,?)", tableName], SafeStr(dic[@"date"]), SafeStr(dic[@"rawData"]), SafeStr([self recordJSONFromDict:dic])];
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
        [self ensureRecordColumnForTable:tableName db:db];
        NSMutableArray *tempDataList = [NSMutableArray array];
        FMResultSet * result = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@", tableName]];
        while ([result next]) {
            NSDictionary *resultDic = [self dictFromRecordJSON:[result stringForColumn:@"record"]];
            if (!resultDic) {
                resultDic = @{
                    @"date":[result stringForColumn:@"date"],
                    @"rawData":[result stringForColumn:@"rawData"],
                };
            }
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

+ (void)ensureRecordColumnForTable:(NSString *)tableName db:(FMDatabase *)db {
    FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"PRAGMA table_info(%@)", tableName]];
    BOOL hasRecord = NO;
    while ([rs next]) {
        if ([[rs stringForColumn:@"name"] isEqualToString:@"record"]) {
            hasRecord = YES;
            break;
        }
    }
    [rs close];
    if (!hasRecord) {
        [db executeUpdate:[NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN record text", tableName]];
    }
}

+ (NSString *)recordJSONFromDict:(NSDictionary *)dic {
    if (![NSJSONSerialization isValidJSONObject:dic]) {
        return nil;
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
    if (!data) {
        return nil;
    }
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

+ (NSDictionary *)dictFromRecordJSON:(NSString *)json {
    if (!ValidStr(json)) {
        return nil;
    }
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    if (!data) {
        return nil;
    }
    id obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if ([obj isKindOfClass:[NSDictionary class]]) {
        return obj;
    }
    return nil;
}

@end
