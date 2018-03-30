//
//  NSFileManager+FJExtension.m
//  DevHandTool
//
//  Created by bearger on 2018/3/29.
//  Copyright © 2018年 Bear. All rights reserved.
//

#import "NSFileManager+FJExtension.h"

@implementation NSFileManager (FJExtension)
-(void)createFJPasteboardDocument
{
    NSString * documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    
    NSError * createPathError;
    NSString * filePath = [NSString stringWithFormat:@"%@/FJPasteboard",documentPath];
    [self createDirectoryAtPath:filePath
    withIntermediateDirectories:YES
                     attributes:nil
                          error:&createPathError];
    if (createPathError)
    {
        NSLog(@"%@",createPathError);
    }
}

-(NSString*)getFJPasteboardDocumentPath {
    NSString * documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString * filePath = [NSString stringWithFormat:@"%@/FJPasteboard",documentPath];
    return filePath;
}
@end
