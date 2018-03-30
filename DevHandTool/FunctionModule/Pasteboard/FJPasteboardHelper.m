//
//  FJPasteboardHelper.m
//  DevHandTool
//
//  Created by bearger on 2018/3/29.
//  Copyright © 2018年 Bear. All rights reserved.
//

#import "FJPasteboardHelper.h"
#import "FJPasteboardItem.h"
#import "NSDate+Utilities.h"
#import "NSFileManager+FJExtension.h"

NSString * const NSPasteboardTypeMIX = @"NSPasteboardTypeMIX";
NSString * const NSPasteboardTypeFJPath = @"NSPasteboardTypeFJPath";
NSString * const NSPasteboardTypeFJImage = @"NSPasteboardTypeFJImage";

@interface FJPasteboardHelper()
@property (strong, nonatomic) NSStatusItem *statusBar;
@property (strong, nonatomic) NSPasteboard * pboard;
@end


@implementation FJPasteboardHelper
SINGLETON_IMPLEMENTION(FJPasteboardHelper, shared)

- (FJPasteboardItem*)transferNSPasteboard
{
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    NSArray *possibleTypes = [pasteboard types];
    
    FJPasteboardItem * item = [FJPasteboardItem new];
    
    if ([possibleTypes containsObject:NSPasteboardTypeString])
    {
        item.content = [pasteboard stringForType:NSPasteboardTypeString];
    }
    
    if ([possibleTypes containsObject:NSFilenamesPboardType])
    {
        item.contentUrls = [pasteboard propertyListForType:NSFilenamesPboardType];
    }
    else if ([possibleTypes containsObject:NSPasteboardTypePNG])
    {
        NSData * pngData = [pasteboard dataForType:NSPasteboardTypePNG];
        NSString * subFix = [NSDate dateWithTimeIntervalSinceNow:[item.time floatValue]].longString;
        NSString * filePath = [NSString stringWithFormat:@"%@/%@.png",[[NSFileManager defaultManager]getFJPasteboardDocumentPath], subFix];
        BOOL writeResult = [[NSFileManager defaultManager] createFileAtPath:filePath contents:pngData attributes:nil];
        if (!writeResult) {
            NSLog(@"Write file fail");
        }
        item.contentUrls = @[filePath];
    }
    item.type = [self judgeType:item.contentUrls];
    return item;
}

- (NSString*)judgeType:(NSArray*)contentUrl
{
    if (contentUrl == nil) {
        return NSPasteboardTypeString;
    }
    __block NSMutableSet<NSString*> * urlType = [NSMutableSet new];
    [contentUrl enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSURL* pathUrl = [[NSURL alloc]initFileURLWithPath:obj];
        NSString * lastComponent = pathUrl.lastPathComponent;
        if ([lastComponent containsString:@"."])
        {
            NSString * typeString = [lastComponent componentsSeparatedByString:@"."].lastObject;
            [urlType addObject:typeString];
        }
        else
        {
            [urlType addObject:NSPasteboardTypeFJPath];
        }
    }];
    if (urlType.count > 1)
    {
        return NSPasteboardTypeMIX;
    }
    else if(urlType.count == 1)
    {
        NSArray * urlTypeArray = [urlType allObjects];
        NSString * fileTypeString = [urlTypeArray[0] lowercaseString];
        if ([fileTypeString isEqualToString:NSPasteboardTypeFJPath])
        {
            return NSPasteboardTypeFJPath;
        }
        NSArray * imgTypes = @[@"jpg",@"png",@"jpeg",@"bmp"];
        if ([imgTypes containsObject:fileTypeString])
        {
            return NSPasteboardTypeFJImage;
        }
    }
    return NSPasteboardTypeString;
}

- (void)setupStatueBar:(NSMenu*)menu
{
    self.statusBar = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    self.statusBar.title = @"FJ";
    self.statusBar.menu = menu;
    self.statusBar.highlightMode = YES;
    
    [self setupPasteBoard];
}

-(void)setupPasteBoard
{
    self.pboard = [NSPasteboard generalPasteboard];
}



@end
