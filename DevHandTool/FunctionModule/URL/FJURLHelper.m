//
//  FJURLHelper.m
//  DevHandTool
//
//  Created by Bear on 2017/12/20.
//  Copyright © 2017年 Bear. All rights reserved.
//

#import "FJURLHelper.h"
#import <YYModel.h>
#import "FJQRCodeVC.h"
#import "FJSaveUrlVC.h"
#import "FJUrlHistoryVC.h"

@interface FJURLHelper ()
@property (unsafe_unretained) IBOutlet NSTextView *enterTextView;
@property (unsafe_unretained) IBOutlet NSTextView *resultTextView;

@property (nonatomic, strong) NSWindowController *qrWindowController;
@property (nonatomic, strong) NSWindow *extraWindow;
@property (nonatomic, strong) FJQRCodeVC *fjQRCodeVC;
@property (nonatomic, strong) FJUrlHistoryVC *historyUrlVC;
@property (nonatomic, strong) FJSaveUrlVC *saveUrlVC;
@end

@implementation FJURLHelper

- (IBAction)onAnalyseButtonClick:(id)sender {
    NSString *urlStr = self.enterTextView.string;
    NSURL * url = [self strToURL:urlStr];
    
    NSDictionary * urlComponent = @{
                                    @"scheme":url.scheme?url.scheme:@"",
                                    @"host":url.host?url.host:@"",
                                    @"port":url.port?url.port:@"",
                                    @"path":url.path?url.path:@"",
                                    @"parameterString":url.parameterString?url.parameterString:@"",
                                    @"query":url.query?url.query:@"",
                                    @"fragment":url.fragment?url.query:@""
                                    };
    
    NSError * error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:urlComponent
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (!error) {
        NSString * str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        [self.resultTextView setString:str];
    }
    else{
        self.resultTextView.string = @"解析失败";
    }
}

- (IBAction)onEncodeButtonClick:(id)sender {
    self.resultTextView.string = [self encodeString:self.enterTextView.string];
}

- (IBAction)onDecodeButtonClick:(id)sender {
    self.resultTextView.string = [self decodeURLString:self.enterTextView.string];
}

- (IBAction)onQRCodeClick:(id)sender {
    
    self.fjQRCodeVC = [[FJQRCodeVC alloc]initWithNibName:@"FJQRCodeVC" bundle:[NSBundle mainBundle] QRString:self.enterTextView.string];
    self.extraWindow = [NSWindow windowWithContentViewController:self.fjQRCodeVC];
    [self.extraWindow makeKeyWindow];
    self.extraWindow.title = @"QR Code";
    
    self.qrWindowController = [[NSWindowController alloc]initWithWindow:self.extraWindow];
    [self.qrWindowController showWindow:nil];
    
    
}

- (NSURL*)strToURL:(NSString*)strURL {
    
    NSURL * resultURL = [NSURL URLWithString:strURL];
    
    if (resultURL) {
        return resultURL;
    }
    else{
        NSString * encodeStrURL = [self encodeString:strURL];
        resultURL = [NSURL URLWithString:encodeStrURL];
        if (resultURL) {
            return resultURL;
        }
        else {
            return [NSURL new];
        }
    }
}

- (NSString*)encodeString:(NSString*)unencodedString {

    NSString *encodedString = [unencodedString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return encodedString;
}



//URLDEcode
- (NSString *)decodeURLString:(NSString *)URLString {

    NSString *result = [URLString stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    result = [result stringByRemovingPercentEncoding];
    
    return result;
}

- (IBAction)onSaveButtonClicked:(id)sender {
    
    self.saveUrlVC = [[FJSaveUrlVC alloc]initWithNibName:@"FJSaveUrlVC"
                                                  bundle:[NSBundle mainBundle]
                                                     url:self.enterTextView.string];
    self.extraWindow = [NSWindow windowWithContentViewController:self.saveUrlVC];
    [self.extraWindow makeKeyWindow];
    self.extraWindow.title = @"保存Url";
    
    self.qrWindowController = [[NSWindowController alloc]initWithWindow:self.extraWindow];
    [self.qrWindowController showWindow:nil];

}

- (IBAction)onHistoryButtonClicked:(id)sender {
    
    self.historyUrlVC = [[FJUrlHistoryVC alloc]initWithNibName:@"FJUrlHistoryVC" bundle:nil];
    self.extraWindow = [NSWindow windowWithContentViewController:self.historyUrlVC];
    [self.extraWindow makeKeyWindow];
    self.extraWindow.title = @"URLs";
    
    self.qrWindowController = [[NSWindowController alloc]initWithWindow:self.extraWindow];
    [self.qrWindowController showWindow:nil];
}

@end
