//
//  FJDBUrlHistoryTableManager.m
//  DevHandTool
//
//  Created by Bear on 2018/1/16.
//  Copyright © 2018年 Bear. All rights reserved.
//

#import "FJDBManager.h"
#import "FJDBUrlHistoryTableManager.h"
#import <FMDB.h>

@implementation FJDBUrlHistoryModel
-(NSString *)description{
    return [NSString stringWithFormat: @"name:%@\nurl:%@\ndate:%@",self.name,self.url,self.date];
}
@end

@implementation FJDBManager(FJDBUrlHistoryTableManager)

- (void)insertUrlData:(FJDBUrlHistoryModel*)data {

    FMDatabase * db = [FMDatabase databaseWithPath:PATH_OF_DATABASE];
    if ([db open]) {
        NSString * sql = [NSString stringWithFormat:@"insert into %@ (name, url, date) values(?, ?, ?) ",UrlHistoryTableName];
        BOOL res = [db executeUpdate:sql, data.name, data.url, data.date];
        if (!res) {
            debugLog(@"error to insert data");
        } else {
            debugLog(@"succ to insert data");
        }
        [db close];
    }
}


- (NSMutableArray<FJDBUrlHistoryModel*>*)queryUrlData {
    NSMutableArray * result = [NSMutableArray new];
    FMDatabase * db = [FMDatabase databaseWithPath:PATH_OF_DATABASE];
    if ([db open]) {
        NSString * sql = [NSString stringWithFormat: @"select * from %@", UrlHistoryTableName];
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {

            NSString * name = [rs stringForColumn:@"name"];
            NSString * url = [rs stringForColumn:@"url"];
            NSString * date = [rs stringForColumn:@"date"];
            
            FJDBUrlHistoryModel * model = [FJDBUrlHistoryModel new];
            model.date = date;
            model.name = name;
            model.url = url;
            
            [result addObject:model];
        }
        [db close];
    }
    return result;
    
}

-(BOOL)deleteModel:(FJDBUrlHistoryModel*)model {
    BOOL result = NO;
    FMDatabase * db = [FMDatabase databaseWithPath:PATH_OF_DATABASE];
    if ([db open]) {
        NSString * sql = [NSString stringWithFormat:@"delete from %@ where name=? and url=? and date=?",UrlHistoryTableName];
        result = [db executeUpdate:sql,model.name,model.url,model.date];
        if (!result) {
            debugLog(@"error to delete db data");
        } else {
            debugLog(@"succ to deleta db data");
        }
        [db close];
    }
    return result;
}

- (void)clearAllUrlData {
    
    FMDatabase * db = [FMDatabase databaseWithPath:PATH_OF_DATABASE];
    if ([db open]) {
        NSString * sql = [NSString stringWithFormat:@"delete from %@",UrlHistoryTableName];
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
