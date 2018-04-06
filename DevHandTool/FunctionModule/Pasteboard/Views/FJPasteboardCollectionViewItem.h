//
//  FJPasteboardCollectionViewItem.h
//  DevHandTool
//
//  Created by bearger on 2018/4/3.
//  Copyright © 2018年 Bear. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class FJPasteboardItem;
@interface FJPasteboardCollectionViewItem : NSCollectionViewItem
- (void)bindData:(FJPasteboardItem *)data ;
@end
