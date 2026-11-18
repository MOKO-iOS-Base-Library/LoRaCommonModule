//
//  MKLoRaLogDatabaseManager.m
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/18.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKLoRaLogDatabaseManager.h"

#import "FMDB.h"

#import "MKMacroDefines.h"

@implementation MKLoRaLogDatabaseManager

+ (void)insertLogDatas:(NSArray <NSDictionary *>*)logList
            macAddress:(NSString *)macAddress
          databaseName:(NSString *)databaseName
             tableName:(NSString *)tableName
              sucBlock:(void (^)(void))sucBlock
           failedBlock:(void (^)(NSError *error))failedBlock {
    if (!logList) {
        [self operationInsertFailedBlock:failedBlock];
        return ;
    }
    NSString *dbPath = kFilePath(databaseName);
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        [self operationInsertFailedBlock:failedBlock];
        return;
    }
    NSString *sqlCreateTable = [NSString stringWithFormat:@"create table if not exists %@ (macAddress text,date text,logDetails text)", tableName];
    BOOL resCreate = [db executeUpdate:sqlCreateTable];
    if (!resCreate) {
        [db close];
        [self operationInsertFailedBlock:failedBlock];
        return;
    }
    [[FMDatabaseQueue databaseQueueWithPath:dbPath] inDatabase:^(FMDatabase *db) {
        for (NSDictionary *logDic in logList) {
            BOOL exist = NO;
            FMResultSet * result = [db executeQuery:[NSString stringWithFormat:@"select * from %@ where macAddress = ? and date = ?", tableName], macAddress, SafeStr(logDic[@"date"])];
            while (result.next) {
                exist = YES;
            }
            if (exist) {
                //存在该设备，更新设备
                [db executeUpdate:[NSString stringWithFormat:@"UPDATE %@ SET logDetails = ? where macAddress = ?", tableName], SafeStr(logDic[@"logDetails"]), macAddress];
            }else{
                //不存在，插入设备
                [db executeUpdate:[NSString stringWithFormat:@"INSERT INTO %@ (macAddress,date,logDetails) VALUES (?,?,?)", tableName], macAddress, SafeStr(logDic[@"date"]), SafeStr(logDic[@"logDetails"])];
            }
        }
        
        if (sucBlock) {
            moko_dispatch_main_safe(^{
                sucBlock();
            });
        }
        [db close];
    }];
}

+ (void)readLocalLogsWithMacAddress:(NSString *)macAddress
                       databaseName:(NSString *)databaseName
                          tableName:(NSString *)tableName
                           sucBlock:(void (^)(NSArray <NSDictionary *>*logList))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *dbPath = kFilePath(databaseName);
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        [self operationGetDataFailedBlock:failedBlock];
        return;
    }
    [[FMDatabaseQueue databaseQueueWithPath:dbPath] inDatabase:^(FMDatabase *db) {
        NSMutableArray *tempDataList = [NSMutableArray array];
        FMResultSet * result = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ where macAddress = ?", tableName], macAddress];
        while ([result next]) {
            NSDictionary *dic = @{
                @"macAddress":SafeStr([result stringForColumn:@"macAddress"]),
                @"logDetails":SafeStr([result stringForColumn:@"logDetails"]),
                @"date":SafeStr([result stringForColumn:@"date"]),
            };
        
            [tempDataList addObject:dic];
        }
        if (sucBlock) {
            moko_dispatch_main_safe(^{
                sucBlock(tempDataList);
            });
        }
        [db close];
    }];
}

+ (void)deleteDatasWithMacAddress:(NSString *)macAddress
                     databaseName:(NSString *)databaseName
                        tableName:(NSString *)tableName
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *dbPath = kFilePath(databaseName);
    [[FMDatabaseQueue databaseQueueWithPath:dbPath] inDatabase:^(FMDatabase *db) {
        BOOL result = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@ where macAddress = ?", tableName], macAddress];
        if (!result) {
            [self operationDeleteFailedBlock:failedBlock];
            return;
        }
        if (sucBlock) {
            moko_dispatch_main_safe(^{
                sucBlock();
            });
        }
        [db close];
    }];
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
