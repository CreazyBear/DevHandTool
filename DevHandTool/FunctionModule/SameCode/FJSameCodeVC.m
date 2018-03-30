//
//  FJSameCodeVC.m
//  DevHandTool
//
//  Created by 熊伟 on 2017/12/20.
//  Copyright © 2017年 Bear. All rights reserved.
//

#import "FJSameCodeVC.h"
#import <STPrivilegedTask.h>

@interface FJSameCodeVC ()
@property (weak) IBOutlet NSTextField *pathTextField;
@property (weak) IBOutlet NSButton *browseButton;
@property (weak) IBOutlet NSButton *searchButton;
@property (weak) IBOutlet NSButtonCell *isCompareFunction;
@property (unsafe_unretained) IBOutlet NSTextView *resultTextView;
@property (weak) IBOutlet NSProgressIndicator *progressIndicator;

@end

@implementation FJSameCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [_resultTextView setString:@"检索XCode项目中 .m 文件的重复性代码。需要先自行安装 pip install simhash"];
}

- (IBAction)onBrowseButtonClicked:(id)sender {
    // Show an open panel
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setCanChooseDirectories:YES];
    [openPanel setCanChooseFiles:NO];
    
    BOOL okButtonPressed = ([openPanel runModal] == NSModalResponseOK);
    if (okButtonPressed) {
        // Update the path text field
        NSString *path = [[openPanel URL] path];
        [self.pathTextField setStringValue:path];
    }
}

- (IBAction)onSearchButtonClicked:(id)sender {
    
    NSString *sourcePath = self.pathTextField.stringValue;
    if (!sourcePath || sourcePath.length<=0) {
        [self showAlertWithText:@"先设置包含代码文件夹的路径"];
        return;
    }
    BOOL isCompareFunction = self.isCompareFunction.state;
    NSString *scriptPath = [[NSBundle mainBundle]pathForResource:@"SameCodeFinder" ofType:@"py"];
    if (!scriptPath || scriptPath.length<=0) {
        [self showAlertWithText:@"找不到脚本文件"];
        return;
    }
    
    NSString *mainScriptPath = [[NSBundle mainBundle]pathForResource:@"mainScript" ofType:@"sh"];
    if (!mainScriptPath || mainScriptPath.length<=0) {
        [self showAlertWithText:@"找不到脚本文件"];
        return;
    }
    self.progressIndicator.hidden = NO;
    [self.progressIndicator startAnimation:self];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        STPrivilegedTask *privilegedTask = [[STPrivilegedTask alloc] init];
        
        NSMutableArray *components = components = @[@"/bin/sh",mainScriptPath,scriptPath,sourcePath,@".m",@"--max-distance=10",@"--min-linecount=3"].mutableCopy;
        if (isCompareFunction) {
            components = @[@"/bin/sh",mainScriptPath,scriptPath,sourcePath,@".m",@"--max-distance=10",@"--min-linecount=3",@"--functions"].mutableCopy;
        }
        
        NSString *launchPath = components[0];
        [components removeObjectAtIndex:0];
        
        [privilegedTask setLaunchPath:launchPath];
        [privilegedTask setArguments:components];
        [privilegedTask setCurrentDirectoryPath:[[NSBundle mainBundle] resourcePath]];
        //set it off
        OSStatus err = [privilegedTask launch];
        if (err != errAuthorizationSuccess) {
            
            if (err == errAuthorizationCanceled) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.progressIndicator stopAnimation:self];
                    self.progressIndicator.hidden = YES;
                    self.resultTextView.string = @"User cancelled";
                });
                return;
            }  else {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.progressIndicator stopAnimation:self];
                    self.progressIndicator.hidden = YES;
                    self.resultTextView.string = [NSString stringWithFormat:@"Something went wrong: %d", (int)err];
                });
                return;
            }
            
        }
        
        [privilegedTask waitUntilExit];
        //TODO:同步显示执行细节
        //        Success!  Now, start monitoring output file handle for data
        //        NSFileHandle *readHandle = [privilegedTask outputFileHandle];
        //        NSData *outputData = [readHandle readDataToEndOfFile];
        //        NSString *outputString = [[NSString alloc] initWithData:outputData encoding:NSUTF8StringEncoding];
        //        NSLog(@"%@",outputString);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.progressIndicator stopAnimation:self];
            self.progressIndicator.hidden = YES;
            NSString *outFilePath = [[NSBundle mainBundle]pathForResource:@"out" ofType:@"txt"];
            self.resultTextView.string = [NSString stringWithContentsOfFile:outFilePath encoding:NSUTF8StringEncoding error:nil];
        });
    });
    
}

- (void)showAlertWithText:(NSString *)text {
    
    NSAlert *alert = [[NSAlert alloc]init];
    alert.messageText = text;
    [alert addButtonWithTitle:@"确定"];
    [alert beginSheetModalForWindow:[NSApplication sharedApplication].windows[0] completionHandler:^(NSModalResponse returnCode) {
    }];
}



@end
