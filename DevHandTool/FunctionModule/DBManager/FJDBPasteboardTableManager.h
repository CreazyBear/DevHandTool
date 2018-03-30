//
//  FJDBPasteboardTableManager.h
//  DevHandTool
//
//  Created by bearger on 2018/3/29.
//  Copyright © 2018年 Bear. All rights reserved.
//

#import "FJDBManager.h"
#import "FJPasteboardItem.h"


@interface FJDBManager (FJDBPasteboardTableManager)
- (void) insertData:(FJPasteboardItem*)data;
- (NSMutableArray<FJPasteboardItem*>*) queryData;
- (void) clearAllData;
- (BOOL) deleteModel:(FJPasteboardItem*)model;
@end
