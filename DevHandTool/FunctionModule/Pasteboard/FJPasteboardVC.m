//
//  FJPasteboardVC.m
//  DevHandTool
//
//  Created by bearger on 2018/3/29.
//  Copyright © 2018年 Bear. All rights reserved.
//

#import "FJPasteboardVC.h"
#import "FJDBManager.h"
#import "FJDBPasteboardTableManager.h"
#import "FJPasteboardItem.h"
#import "FJPasteboardCollectionViewItem.h"
#import <Cocoa/Cocoa.h>
#import "FJPasteboardHelper.h"

@interface FJPasteboardVC ()<NSCollectionViewDelegate,NSCollectionViewDataSource>
@property (weak) IBOutlet NSCollectionView *collectionView;
@property (strong) NSMutableArray<FJPasteboardItem*> *dataSource;
@property (nonatomic, strong) NSWindow *detailWindow;
@end

@implementation FJPasteboardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.allowsMultipleSelection = NO;
    self.collectionView.selectable = YES;
    [self.collectionView registerClass:FJPasteboardCollectionViewItem.class forItemWithIdentifier:NSStringFromClass(FJPasteboardCollectionViewItem.class)];
}

-(void)viewWillAppear {
    [super viewWillAppear];
    [self setupDataSource];
    [self.collectionView reloadData];
}

-(void)setupDataSource {
    self.dataSource = [[FJDBManager defaultManager] queryData];
    __block BOOL hasChanged = NO;
    [self.dataSource enumerateObjectsUsingBlock:^(FJPasteboardItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.content == nil && obj.contentUrls == nil) {
            [[FJDBManager defaultManager] deleteModel:obj];
            hasChanged = YES;
        }
    }];
    if (hasChanged) {
        self.dataSource = [[FJDBManager defaultManager] queryData];
    }
}


#pragma mark - NSCollectionViewDelegate,NSCollectionViewDataSource
-(NSInteger)collectionView:(NSCollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section {
    NSInteger count =  self.dataSource.count;
    return count;
}

-(NSCollectionViewItem *)collectionView:(NSCollectionView *)collectionView
    itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath {
    NSCollectionViewItem * item = [collectionView makeItemWithIdentifier:NSStringFromClass(FJPasteboardCollectionViewItem.class) forIndexPath:indexPath];
    if ([item isKindOfClass:FJPasteboardCollectionViewItem.class]) {
        FJPasteboardCollectionViewItem * convertItem = (FJPasteboardCollectionViewItem*)item;
        [convertItem bindData:self.dataSource[indexPath.item]];
        return convertItem;
    }
    return item;
}

-(void)collectionView:(NSCollectionView *)collectionView didSelectItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths {
    
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, BOOL * _Nonnull stop) {
        FJPasteboardItem * item = self.dataSource[obj.item];
        if ([item.type isEqualToString:NSPasteboardTypeFJImage]) {
            NSString * imgPathString = item.contentUrls[0];
            [[NSWorkspace sharedWorkspace]openURL:[NSURL fileURLWithPath:imgPathString]];
            
        }
        [[FJPasteboardHelper shared]updateSelectItem:item];
        [self.dataSource removeObject:item];
        [self.dataSource insertObject:item atIndex:0];
        [collectionView reloadData];
    }];
}

@end
