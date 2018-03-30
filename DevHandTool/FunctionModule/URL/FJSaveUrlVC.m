//
//  FJSaveUrlVC.m
//  DevHandTool
//
//  Created by Bear on 2018/1/22.
//  Copyright © 2018年 Bear. All rights reserved.
//

#import "FJSaveUrlVC.h"
#import "FJDBManager.h"
#import "FJDBUrlHistoryTableManager.h"
#import "NSDate+Utilities.h"

@interface FJSaveUrlVC ()
@property (weak) IBOutlet NSTextField *tagTextView;
@property (nonatomic, strong) NSString *urlStr;
@end

@implementation FJSaveUrlVC

-(instancetype)initWithNibName:(NSNibName)nibNameOrNil
                        bundle:(NSBundle *)nibBundleOrNil
                           url:(NSString*)str
{
    self = [super init];
    if (self) {
        self.urlStr = str;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.urlStr = @"";
    }
    return self;
}


- (IBAction)onSaveButtonClicked:(id)sender {
    
    NSString * tag = self.tagTextView.stringValue;
    FJDBUrlHistoryModel * model = [FJDBUrlHistoryModel new];
    model.name = tag;
    model.url = _urlStr;
    model.date = [NSDate new].shortString;
    
    [[FJDBManager defaultManager] insertUrlData:model];
    [self.view.window close];
}

@end
