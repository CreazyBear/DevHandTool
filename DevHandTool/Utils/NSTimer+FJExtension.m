//
//  NSTimer+FJExtension.m
//  DevHandTool
//
//  Created by bearger on 2018/3/29.
//  Copyright © 2018年 Bear. All rights reserved.
//

#import "NSTimer+FJExtension.h"

@implementation NSTimer (FJExtension)
-(void)pause
{
    [self setFireDate:[NSDate distantFuture]];
}

-(void)play
{
    [self setFireDate:[NSDate distantPast]];
}

@end
