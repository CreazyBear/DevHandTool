//
//  NSFileManager+FJExtension.h
//  DevHandTool
//
//  Created by bearger on 2018/3/29.
//  Copyright © 2018年 Bear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (FJExtension)
-(void)createFJPasteboardDocument;
-(NSString*)getFJPasteboardDocumentPath;
@end
