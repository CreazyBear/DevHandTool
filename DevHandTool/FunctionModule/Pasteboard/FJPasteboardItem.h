//
//  FJPasteboardItem.h
//  DevHandTool
//
//  Created by bearger on 2018/3/29.
//  Copyright © 2018年 Bear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FJPasteboardItem : NSObject

@property (nonatomic, strong) NSString *time;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, strong) NSArray *contentUrls;


@end
