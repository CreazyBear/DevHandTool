//
//  FJDBManager.h
//  DevHandTool
//
//  Created by Bear on 2018/1/16.
//  Copyright © 2018年 Bear. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

extern NSString * const UrlHistoryTableName;
extern NSString * const FJPasteboardTableName;

@interface FJDBManager : NSObject

SINGLETON_INTERFACE(FJDBManager, defaultManager)

- (void)createDBIfneeded;

@end
