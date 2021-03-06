//
//  FJUnuseedImportVC.m
//  DevHandTool
//
//  Created by 熊伟 on 2017/12/20.
//  Copyright © 2017年 Bear. All rights reserved.
//

#import "FJUnuseedImportVC.h"
#import "CATClearProjectTool.h"


@interface FJUnuseedImportVC ()<CATClearProjectToolDelegate>

@property (weak) IBOutlet NSTextField *txtPath;
@property (weak) IBOutlet NSTextView *txtResult;
@property (weak) IBOutlet NSTextView *txtFilter;
@property (nonatomic,strong) CATClearProjectTool* clearProjectTool;

@end

@implementation FJUnuseedImportVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.clearProjectTool.delegate = self;
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}

#pragma mark -- UIResponder

- (IBAction)searchButtonClicked:(id)sender {
    _txtResult.string = @"searching all classes...";
    [self.clearProjectTool startSearchWithXcodeprojFilePath:_txtPath.stringValue];
}

- (IBAction)clearButtonClicked:(id)sender {
    [self _addFilter];
    [self.clearProjectTool clearFileAndMetaData];
}

#pragma mark -- CATClearProjectToolDelegate

-(void)searchAllClassesSuccess:(NSMutableDictionary *)dic{
    NSString* msg = @"searching all classes success:\n";
    dispatch_async(dispatch_get_main_queue(), ^{
        [_txtResult setString:[msg stringByAppendingString:[self _getClassNamesFromDic:dic]]];
    });
}

-(void)searchUnUsedClassesSuccess:(NSMutableDictionary *)dic{
    NSString* msg = @"search unused classes success:\n";
    dispatch_async(dispatch_get_main_queue(), ^{
        [_txtResult setString: [msg stringByAppendingString:[self _getClassNamesFromDic:dic]]];
    });
    
}

-(void)clearUnUsedClassesSuccess:(NSMutableDictionary *)dic{
    NSString* msg = @"clear unused classes success:\n";
    dispatch_async(dispatch_get_main_queue(), ^{
        [_txtResult setString: [msg stringByAppendingString:[self _getClassNamesFromDic:dic]]];
    });
}

#pragma mark -- helper

-(NSString *)_getClassNamesFromDic:(NSMutableDictionary *)dic{
    NSArray* keys = [dic allKeys];
    NSString* classNames = @"";
    for (NSString* className in keys) {
        classNames = [classNames stringByAppendingString:[NSString stringWithFormat:@"\n%@",className]];
    }
    return classNames;
}

-(void)_addFilter{
    NSString* strFilter = [NSString stringWithString:_txtFilter.string];
    if (strFilter && strFilter.length > 0) {
        if ([strFilter containsString:@","]) {
            NSArray* array = [strFilter componentsSeparatedByString:@","];
            [_clearProjectTool setFliterClasses:array];
        }else{
            [_clearProjectTool setFliterClasses:[NSArray arrayWithObject:strFilter]];
        }
    }
}

#pragma mark -- properties

/**
 *  get clearProjectTool
 *
 *  @return clearProjectTool
 */
-(CATClearProjectTool *)clearProjectTool{
    if (!_clearProjectTool) {
        _clearProjectTool = [[CATClearProjectTool alloc]init];
    }
    return _clearProjectTool;
}


#pragma mark -- dealloc

-(void)dealloc{
    _clearProjectTool = nil;
}

@end
