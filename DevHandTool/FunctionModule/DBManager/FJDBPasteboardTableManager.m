;//
//  FJDBPasteboardTableManager.m
//  DevHandTool
//
//  Created by bearger on 2018/3/29.
//  Copyright © 2018年 Bear. All rights reserved.
//

#import "FJDBPasteboardTableManager.h"
#import <FMDB.h>

@implementation FJDBManager (FJDBPasteboardTableManager)

- (void)insertData:(FJPasteboardItem*)data {
    
    FMDatabase * db = [FMDatabase databaseWithPath:PATH_OF_DATABASE];
    if ([db open]) {
        NSString * sql = [NSString stringWithFormat:@"insert into %@ (time, content, type, contentUrls) values(?, ?, ?, ?) ",FJPasteboardTableName];
        NSData *contentUrlsData = [NSKeyedArchiver archivedDataWithRootObject:data.contentUrls];
        BOOL res = [db executeUpdate:sql, data.time, data.content, data.type, contentUrlsData];
        if (!res) {
            debugLog(@"error to insert data");
        } else {
            debugLog(@"succ to insert data");
        }
        [db close];
    }
}


- (NSMutableArray<FJPasteboardItem*>*)queryData {
    NSMutableArray * result = [NSMutableArray new];
    FMDatabase * db = [FMDatabase databaseWithPath:PATH_OF_DATABASE];
    if ([db open]) {
        NSString * sql = [NSString stringWithFormat: @"select * from %@ order by time desc;", FJPasteboardTableName];
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            
            NSString * time = [rs stringForColumn:@"time"];
            NSString * content = [rs stringForColumn:@"content"];
            NSString * type = [rs stringForColumn:@"type"];
            NSData * contentUrlsData = [rs dataForColumn:@"contentUrls"];
            NSArray * contentUrls = [NSKeyedUnarchiver unarchiveObjectWithData:contentUrlsData];
            
            FJPasteboardItem * model = [FJPasteboardItem new];
            model.time = time;
            model.content = content;
            model.type = type;
            model.contentUrls = contentUrls;
            
            [result addObject:model];
        }
        [db close];
    }
    return result;
}

- (FJPasteboardItem*)queryFirstData {
    NSMutableArray * result = [NSMutableArray new];
    FMDatabase * db = [FMDatabase databaseWithPath:PATH_OF_DATABASE];
    if ([db open]) {
        NSString * sql = [NSString stringWithFormat: @"select * from %@ order by time desc limit 1;", FJPasteboardTableName];
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            
            NSString * time = [rs stringForColumn:@"time"];
            NSString * content = [rs stringForColumn:@"content"];
            NSString * type = [rs stringForColumn:@"type"];
            NSData * contentUrlsData = [rs dataForColumn:@"contentUrls"];
            NSArray * contentUrls = [NSKeyedUnarchiver unarchiveObjectWithData:contentUrlsData];
            
            FJPasteboardItem * model = [FJPasteboardItem new];
            model.time = time;
            model.content = content;
            model.type = type;
            model.contentUrls = contentUrls;
            
            [result addObject:model];
        }
        [db close];
    }
    return result.firstObject;
}


-(BOOL)deleteModel:(FJPasteboardItem*)model {
    BOOL result = NO;
    FMDatabase * db = [FMDatabase databaseWithPath:PATH_OF_DATABASE];
    if ([db open]) {
        NSString * sql = [NSString stringWithFormat:@"delete from %@ where time=?",FJPasteboardTableName];
        result = [db executeUpdate:sql,model.time];
        if (!result) {
            debugLog(@"error to delete db data");
        } else {
            debugLog(@"succ to deleta db data");
        }
        [db close];
    }
    return result;
}

- (void)clearAllData {
    
    FMDatabase * db = [FMDatabase databaseWithPath:PATH_OF_DATABASE];
    if ([db open]) {
        NSString * sql = [NSString stringWithFormat:@"delete from %@",FJPasteboardTableName];
        BOOL res = [db executeUpdate:sql];
        if (!res) {
            debugLog(@"error to delete db data");
        } else {
            debugLog(@"succ to deleta db data");
        }
        [db close];
    }
}

@end
