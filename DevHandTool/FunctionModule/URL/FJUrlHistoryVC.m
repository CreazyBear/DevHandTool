
//
//  FJUrlHistoryVC.m
//  DevHandTool
//
//  Created by Bear on 2018/1/22.
//  Copyright © 2018年 Bear. All rights reserved.
//

#import "FJUrlHistoryVC.h"
#import "FJDBUrlHistoryTableManager.h"
#import "FJDBManager.h"

@interface FJUrlHistoryVC ()<NSTableViewDelegate, NSTableViewDataSource>
@property (weak) IBOutlet NSTableView *resultsTableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMenu * rightClickMenu;
@end

@implementation FJUrlHistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.resultsTableView.allowsEmptySelection = YES;
    self.resultsTableView.allowsMultipleSelection = YES;
    [self setupDataSource];
    
}

#pragma mark - data
-(void)setupDataSource {
     self.dataSource = [[FJDBManager defaultManager] queryUrlData];
}

#pragma mark - tableview action

- (IBAction)onDeleteButtonClicked:(id)sender {
    
    NSArray *results = [self.dataSource copy];
    NSIndexSet *selectedIndexSet = self.resultsTableView.selectedRowIndexes;
    NSUInteger index = [selectedIndexSet firstIndex];
    while (index != NSNotFound) {
        if (index < results.count) {
            FJDBUrlHistoryModel *model = [results objectAtIndex:index];
            [[FJDBManager defaultManager] deleteModel:model];
            [self.dataSource removeObject:model];
        }
        index = [selectedIndexSet indexGreaterThanIndex:index];
    }
    [self.resultsTableView reloadData];
}


#pragma mark - NSTableViewDelegate, NSTableViewDataSource
-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return self.dataSource.count;
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    FJDBUrlHistoryModel * model = self.dataSource[row];
    NSString *columnIdentifier = [tableColumn identifier];
    if ([columnIdentifier isEqualToString:@"tag"]) {
        return model.name ;
    } else if ([columnIdentifier isEqualToString:@"date"]) {
        return model.date;
    } else if ([columnIdentifier isEqualToString:@"url"]) {
        return model.url;
    } else {
        return @"无效列";
    }
}

@end
