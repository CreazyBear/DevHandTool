//
//  FJDBManager.m
//  DevHandTool
//
//  Created by Bear on 2018/1/16.
//  Copyright © 2018年 Bear. All rights reserved.
//

#import "FJDBManager.h"
#import <FMDB.h>


NSString * const UrlHistoryTableName = @"UrlHistory";
NSString * const FJPasteboardTableName = @"FJPasteboard";

@interface FJDBManager ()

@property (nonatomic, strong) NSString * dbPath;
@property (nonatomic, strong) FMDatabase * db;

@end

@implementation FJDBManager

SINGLETON_IMPLEMENTION(FJDBManager, defaultManager)

- (void)createDBIfneeded {
    
    NSString * path = PATH_OF_DATABASE;
    self.dbPath = path;
    _db = [FMDatabase databaseWithPath:self.dbPath];
    if ([_db open]) {
        [self createUrlHistoryTableWithDB:self.db];
        [self createFJPasteboardTableWithDB:self.db];
        [_db close];
    } else {
        debugLog(@"error when open db");
    }
}

- (void)createUrlHistoryTableWithDB:(FMDatabase*)db {
    NSString * sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL , 'name' VARCHAR(30), 'url' TEXT, 'date' 'TEXT')",UrlHistoryTableName];
    BOOL res = [db executeUpdate:sql];
    if (!res) {
        debugLog(@"error when creating db table");
    } else {
        debugLog(@"succ to creating db table");
    }
}

- (void)createFJPasteboardTableWithDB:(FMDatabase*)db {
    NSString * sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL , 'time' TEXT, 'content' TEXT, 'type' 'TEXT', 'contentUrls' 'BLOB')",FJPasteboardTableName];
    BOOL res = [db executeUpdate:sql];
    if (!res) {
        debugLog(@"error when creating db table");
    } else {
        debugLog(@"succ to creating db table");
    }
}
@end
