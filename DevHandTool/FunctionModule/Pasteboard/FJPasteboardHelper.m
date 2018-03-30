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
#import "FJDBPasteboardTableManager.h"
#import "FJDBManager.h"
#import "NSImage+FJExtension.h"
#import <ServiceManagement/ServiceManagement.h>

NSString * const NSPasteboardTypeMIX = @"NSPasteboardTypeMIX";
NSString * const NSPasteboardTypeFJPath = @"NSPasteboardTypeFJPath";
NSString * const NSPasteboardTypeFJImage = @"NSPasteboardTypeFJImage";

@interface FJPasteboardHelper()
@property (nonatomic, strong) NSMenu *menu;
@property (nonatomic, strong) NSStatusItem *statusBar;
@property (nonatomic, strong) NSPasteboard * pboard;
@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, strong) NSMutableArray<FJPasteboardItem*> * pasteboardItemsArray;
@property (nonatomic, strong) NSPasteboardItem *lastPasteboardItemTemp;

@property (nonatomic, assign) NSInteger maxCount;
@property (nonatomic, assign) NSInteger showTime;
@property (nonatomic, assign) NSInteger fontSize;
@property (nonatomic, assign) NSInteger MaxVisibleChars;
@end


@implementation FJPasteboardHelper
SINGLETON_IMPLEMENTION(FJPasteboardHelper, shared)

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.maxCount = 100;
        self.showTime = 1;
        self.fontSize = 12;
        self.MaxVisibleChars = 50;
    }
    return self;
}
#pragma mark - public
- (void)startService:(NSMenu*)menu
{
    self.statusBar = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    self.statusBar.title = @"FJ";
    self.statusBar.menu = menu;
    self.statusBar.highlightMode = YES;
    self.menu = menu;
    
    [self setupPasteBoard];
    [self setupObserverTimer];
}

-(void)endService {
    [self.timer invalidate];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - getter and setter
-(NSMutableArray<FJPasteboardItem *> *)pasteboardItemsArray
{
    if (!_pasteboardItemsArray) {
        _pasteboardItemsArray = [NSMutableArray array];
    }
    return _pasteboardItemsArray;
}

#pragma mark - private

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
        NSString * subFix = [NSDate dateWithTimeIntervalSince1970:[item.time floatValue]].longString;
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

-(void)setupPasteBoard
{
    self.pboard = [NSPasteboard generalPasteboard];
    
    [self setupObserverTimer];
}

-(void)setupObserverTimer
{
    self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerFire:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    [self.timer fire];
}


- (void)timerFire:(id)sender
{
    NSPasteboardItem * pboardItem = [[_pboard pasteboardItems] lastObject];
    if (!_lastPasteboardItemTemp || _lastPasteboardItemTemp != pboardItem)
    {
        if (!pboardItem)
        {
            return;
        }
        _lastPasteboardItemTemp = pboardItem;
        FJPasteboardItem * item = [[FJPasteboardHelper shared]transferNSPasteboard];
        if ([item.type isEqualToString: NSPasteboardTypeString]) {
            if([item.content isEqualToString:self.pasteboardItemsArray.firstObject.content])
            {
                return;
            }
        }
        [self.pasteboardItemsArray insertObject:item atIndex:0];
        [[FJDBManager defaultManager]insertData:item];
        [self addMenuItem:item atIndex:0];
    }
}


- (void)addMenuItem:(FJPasteboardItem *) item atIndex:(NSInteger)index
{
    
    NSMenuItem * menuItem = [[NSMenuItem alloc] initWithTitle:@"" action:@selector(menuItemSelect:) keyEquivalent:@""];
    __block NSMenuItem * pboardMenuItem = nil;
    [self.menu.itemArray enumerateObjectsUsingBlock:^(NSMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.title isEqualToString:@"粘贴板"]) {
            pboardMenuItem = obj;
            *stop = YES;
        }
    }];
    if (!pboardMenuItem) {
        pboardMenuItem = [[NSMenuItem alloc] initWithTitle:@"粘贴板" action:nil keyEquivalent:@""];
        [self.menu addItem:pboardMenuItem];
    }
    
    NSMenu *subMenu = [[NSMenu alloc] initWithTitle:@"粘贴板"];
    [pboardMenuItem setSubmenu:subMenu];
    [subMenu insertItem:menuItem atIndex:index];

    [menuItem setToolTip:item.content];
    
    NSDate * time = [NSDate dateWithTimeIntervalSince1970:[item.time floatValue]];
    NSString * content = item.content;
    NSString * type = item.type;
    
    NSString * timeStr = nil;
    NSString * hourFormat = time.hour>9 ? @"%ld" : @"0%ld";
    NSString * dayFormat = time.day>9 ? @"%ld" : @"0%ld";
    NSString * minuteFormat = time.minute>9 ? @"%ld" : @"0%ld";
    NSString * monthFormat = time.month>9 ? @"%ld" : @"0%ld";
    NSString * yearFormat = time.year>9 ? @"%ld" : @"0%ld";
    
    if ([time isToday])
    {
        NSString * formatter = [NSString stringWithFormat:@"%@:%@",hourFormat,minuteFormat];
        timeStr = [NSString stringWithFormat:formatter,time.hour,time.minute];
    }
    else if([time isThisMonth])
    {
        NSString * formatter = [NSString stringWithFormat:@"%@:%@",dayFormat,hourFormat];
        timeStr = [NSString stringWithFormat:formatter,time.day,time.hour];
    }
    else if([time isThisYear])
    {
        NSString * formatter = [NSString stringWithFormat:@"%@:%@",monthFormat,dayFormat];
        timeStr = [NSString stringWithFormat:formatter,time.month,time.day];
    }
    else
    {
        NSString * formatter = [NSString stringWithFormat:@"%@:%@",yearFormat,monthFormat];
        timeStr = [NSString stringWithFormat:formatter,time.year,time.month];
    }
    
    dispatch_block_t setMenuPropsBlock = ^{
        NSString * stringContent = (NSString*)content;
        NSString * stringDetail = [content substringToIndex:MIN(self.MaxVisibleChars,stringContent.length)];
        if (!stringDetail || stringDetail.length <= 0 ) {
            stringDetail = @"【图片】";
        }
        NSString * stringTail = (stringContent.length <= self.MaxVisibleChars) ? @"" : @"...";
        if (self.showTime)
        {
            menuItem.title = [NSString stringWithFormat:@"【%@】 %@%@", timeStr, stringDetail, stringTail];
        }
        else
        {
            menuItem.title = [NSString stringWithFormat:@" %@%@", stringDetail, stringTail];
        }
        
        NSMutableAttributedString * attributeString = [[NSMutableAttributedString alloc]initWithString:menuItem.title];
        [attributeString addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:self.fontSize] range:NSMakeRange(0, menuItem.title.length)];
        [menuItem setAttributedTitle:attributeString];
        
    };
    
    if ([type isEqualToString:NSPasteboardTypeString])
    {
        setMenuPropsBlock();
    }
    else if([type isEqualToString:NSPasteboardTypeFJImage])
    {
        setMenuPropsBlock();
        if (item.contentUrls && item.contentUrls.count > 0)
        {
            NSString * imgPathString = item.contentUrls[0];
            NSData * imageData = [NSData dataWithContentsOfFile:imgPathString];
            NSImage * image = [[NSImage alloc]initWithData:imageData];
            image = [image imageWithTargetHeight:100];
            [menuItem setImage:image];
        }
    }
}


- (void)menuItemSelect:(id)sender
{
    NSInteger selectedIndex = [self.menu.itemArray indexOfObject:sender];
    FJPasteboardItem * selectedItem = [self.pasteboardItemsArray objectAtIndex:selectedIndex];
    [self.pasteboardItemsArray removeObjectAtIndex:selectedIndex];
    [[FJDBManager defaultManager]deleteModel:selectedItem];
    [self.menu removeItemAtIndex:selectedIndex];
    NSPasteboard * pboard = [NSPasteboard generalPasteboard];
    [pboard clearContents];
    if ([selectedItem.type isEqualToString: NSPasteboardTypeString])
    {
        NSPasteboardItem * pboardItem = [[NSPasteboardItem alloc] init];
        NSString * strContent = selectedItem.content;
        [pboardItem setString:strContent forType:NSPasteboardTypeString];
        [pboard writeObjects:@[pboardItem]];
    }
    else if([selectedItem.type isEqualToString:NSPasteboardTypeFJPath] ||
            [selectedItem.type isEqualToString:NSPasteboardTypeMIX])
    {
        NSPasteboardItem * pboardItem = [[NSPasteboardItem alloc] init];
        NSString * strContent = [selectedItem.contentUrls componentsJoinedByString:@"\r"];
        [pboardItem setString:strContent forType:NSPasteboardTypeString];
        [pboard writeObjects:@[pboardItem]];
    }
    else if([selectedItem.type isEqualToString:NSPasteboardTypeFJImage])
    {
        if (selectedItem.contentUrls && selectedItem.contentUrls.count == 1)
        {
            NSPasteboardItem * pboardItem = [[NSPasteboardItem alloc] init];
            NSData * imageData = [NSData dataWithContentsOfFile:selectedItem.contentUrls[0]];
            [pboardItem setData:imageData  forType:NSPasteboardTypePNG];
            [pboard writeObjects:@[pboardItem]];
        }
        else
        {
            NSPasteboardItem * pboardItem = [[NSPasteboardItem alloc] init];
            NSString * strContent = [selectedItem.contentUrls componentsJoinedByString:@"\r"];
            [pboardItem setString:strContent forType:NSPasteboardTypeString];
            [pboard writeObjects:@[pboardItem]];
        }
    }
    
}


@end
