//
//  FJDBUrlHistoryTableManager.h
//  DevHandTool
//
//  Created by Bear on 2018/1/16.
//  Copyright © 2018年 Bear. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FJDBManager.h"

@interface FJDBUrlHistoryModel : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *date;

@end

@interface FJDBManager(FJDBUrlHistoryTableManager)

- (void) insertUrlData:(FJDBUrlHistoryModel*)data;
- (NSMutableArray<FJDBUrlHistoryModel*>*) queryUrlData;
- (void) clearAllUrlData;
- (BOOL) deleteUrlModel:(FJDBUrlHistoryModel*)model;
@end
