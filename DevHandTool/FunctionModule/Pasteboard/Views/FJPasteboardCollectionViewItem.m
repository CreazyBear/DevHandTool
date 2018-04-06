//
//  FJPasteboardCollectionViewItem.m
//  DevHandTool
//
//  Created by bearger on 2018/4/3.
//  Copyright © 2018年 Bear. All rights reserved.
//

#import "FJPasteboardCollectionViewItem.h"
#import <Cocoa/Cocoa.h>
#import "FJPasteboardItem.h"
#import "FJPasteboardHelper.h"

@interface FJPasteboardCollectionViewItem ()
@property (nonatomic, strong) NSTextField *textContent;
@property (nonatomic, strong) NSImageView *imageContent;
@end

@implementation FJPasteboardCollectionViewItem

- (instancetype)initWithNibName:(NSNibName)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view = [[NSView alloc]init];
    }
    return self;
}

- (void)bindData:(FJPasteboardItem *)data {
    
    if ([data.type isEqualToString: NSPasteboardTypeString]) {
        self.textContent.stringValue = data.content;
        self.textContent.hidden = NO;
        self.imageContent.hidden = YES;
    }
    else if([data.type isEqualToString:NSPasteboardTypeFJImage]) {
        NSString * imgPathString = data.contentUrls[0];
        NSData * imageData = [NSData dataWithContentsOfFile:imgPathString];
        NSImage * image = [[NSImage alloc]initWithData:imageData];
        self.imageContent.image = image;
        self.textContent.hidden = YES;
        self.imageContent.hidden = NO;
    }
}

-(NSTextField *)textContent {
    if (_textContent) {
        return _textContent;
    }
    _textContent = [[NSTextField alloc]initWithFrame:self.view.bounds];
    _textContent.textColor = [NSColor blackColor];
    _textContent.font = [NSFont systemFontOfSize:14];
    _textContent.backgroundColor = [NSColor whiteColor];
    _textContent.maximumNumberOfLines = 0;
    _textContent.editable = NO;
    [self.view addSubview:_textContent];
    return _textContent;
}

-(NSImageView *)imageContent {
    if (_imageContent) {
        return _imageContent;
    }
    _imageContent = [[NSImageView alloc]initWithFrame:self.view.bounds];
    _imageContent.imageAlignment = NSImageAlignCenter;
    [self.view addSubview:_imageContent];
    return _imageContent;
}












@end
