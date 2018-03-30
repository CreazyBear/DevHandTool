//
//  FJPasteboardHelper.h
//  DevHandTool
//
//  Created by bearger on 2018/3/29.
//  Copyright © 2018年 Bear. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

extern NSString * const NSPasteboardTypeMIX;
extern NSString * const NSPasteboardTypeFJPath;
extern NSString * const NSPasteboardTypeFJImage;

@class FJPasteboardItem;

@interface FJPasteboardHelper : NSObject
SINGLETON_INTERFACE(FJPasteboardHelper, shared)

- (void)startService:(NSMenu*)menu;

- (void)endService;

@end
