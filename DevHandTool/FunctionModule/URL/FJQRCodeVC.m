//
//  FJQRCodeVC.m
//  DevHandTool
//
//  Created by Bear on 2017/12/21.
//  Copyright © 2017年 Bear. All rights reserved.
//

#import "FJQRCodeVC.h"
#import "QRCodeImage.h"

@interface FJQRCodeVC ()
@property (nonatomic, strong) NSString *qrStr;
@property (weak) IBOutlet NSImageView *qrImageView;
@property (weak) IBOutlet NSTextField *titleLabel;

@end

@implementation FJQRCodeVC

-(instancetype)initWithNibName:(NSNibName)nibNameOrNil
                        bundle:(NSBundle *)nibBundleOrNil
                      QRString:(NSString*)str {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.qrStr = str;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.maximumNumberOfLines = 2;
    [self.qrImageView setImage:[QRCodeImage qrImageWithContent:self.qrStr size:self.qrImageView.frame.size.width]];
    self.titleLabel.stringValue = self.qrStr;
}

@end
