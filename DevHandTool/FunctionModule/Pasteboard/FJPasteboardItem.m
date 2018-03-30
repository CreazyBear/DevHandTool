//
//  FJPasteboardItem.m
//  DevHandTool
//
//  Created by bearger on 2018/3/29.
//  Copyright © 2018年 Bear. All rights reserved.
//

#import "FJPasteboardItem.h"
#import "NSDate+Utilities.h"

@implementation FJPasteboardItem
- (instancetype)init
{
    self = [super init];
    if (self) {
        _time = [NSString stringWithFormat:@"%f",[[NSDate new] timeIntervalSince1970]];
    }
    return self;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"%@---%@---%@",self.time,self.content,self.type];
}
@end
