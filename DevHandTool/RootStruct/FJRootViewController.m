//
//  FJRootViewController.m
//  DevHandTool
//
//  Created by Bear on 2017/12/20.
//  Copyright © 2017年 Bear. All rights reserved.
//

#import "FJRootViewController.h"
#import "FJURLHelper.h"
#import "FJUnusedImgViewController.h"
#import "FJLinkMapVC.h"
#import "FJSameCodeVC.h"
#import "FJUnuseedImportVC.h"
#import "FJBlueToothVC.h"
#import "FJPasteboardVC.h"
#import "FJPushVC.h"
#import "FJMapVC.h"

@interface FJRootViewController ()
@property (weak) IBOutlet NSTabView *mainTabView;
@property (nonatomic, strong) FJViewController *urlHelper;
@property (nonatomic, strong) FJUnusedImgViewController *fjUnusedImgVC;
@property (nonatomic, strong) FJLinkMapVC *fjLinkMapVC;
@property (nonatomic, strong) FJSameCodeVC *fjSameCodeVC;
@property (nonatomic, strong) FJUnuseedImportVC *fjUnusedImportVC;
@property (nonatomic, strong) FJBlueToothVC *fjBlueToothVC;
@property (nonatomic, strong) FJPasteboardVC *fjPasteboardVC;
@property (nonatomic, strong) FJPushVC *fjPushVC;
@property (nonatomic, strong) FJMapVC *fjMapVC;
@end

@implementation FJRootViewController

- (void)loadView {
    [super loadView];
    
    NSTabViewItem *tabViewItem1 = [self.mainTabView.tabViewItems objectAtIndex:0];
    self.urlHelper = [[FJURLHelper alloc] initWithNibName:@"FJURLHelper" bundle:nil];
    [tabViewItem1 setView:self.urlHelper.view];
    
    NSTabViewItem *tabViewItem2 = [self.mainTabView.tabViewItems objectAtIndex:1];
    self.fjUnusedImgVC = [[FJUnusedImgViewController alloc] initWithNibName:@"FJUnusedImgViewController" bundle:nil];
    [tabViewItem2 setView:self.fjUnusedImgVC.view];
    
    NSTabViewItem *tabViewItem3 = [self.mainTabView.tabViewItems objectAtIndex:2];
    self.fjLinkMapVC = [[FJLinkMapVC alloc]initWithNibName:@"FJLinkMapVC" bundle:nil];
    [tabViewItem3 setView:self.fjLinkMapVC.view];
    
    NSTabViewItem *tabViewItem4 = [self.mainTabView.tabViewItems objectAtIndex:3];
    self.fjSameCodeVC = [[FJSameCodeVC alloc] initWithNibName:@"FJSameCodeVC" bundle:nil];
    [tabViewItem4 setView:self.fjSameCodeVC.view];
    
    NSTabViewItem *tabViewItem5 = [self.mainTabView.tabViewItems objectAtIndex:4];
    self.fjUnusedImportVC = [[FJUnuseedImportVC alloc]initWithNibName:@"FJUnuseedImportVC" bundle:nil];
    [tabViewItem5 setView:self.fjUnusedImportVC.view];
    
    NSTabViewItem *tabViewItem6 = [self.mainTabView.tabViewItems objectAtIndex:5];
    self.fjBlueToothVC = [[FJBlueToothVC alloc]initWithNibName:nil bundle:nil];
    [tabViewItem6 setView:self.fjBlueToothVC.view];
    
    NSTabViewItem *tabViewItem7 = [self.mainTabView.tabViewItems objectAtIndex:6];
    self.fjPasteboardVC = [[FJPasteboardVC alloc]initWithNibName:nil bundle:nil];
    [tabViewItem7 setView:self.fjPasteboardVC.view];
    
    NSTabViewItem *tabViewItem8 = [self.mainTabView.tabViewItems objectAtIndex:7];
    self.fjPushVC = [[FJPushVC alloc]initWithNibName:nil bundle:nil];
    self.fjPushVC.view.frame = self.view.bounds;
    [tabViewItem8 setView:self.fjPushVC.view];
    
    NSTabViewItem *tabViewItem9 = [self.mainTabView.tabViewItems objectAtIndex:8];
    self.fjMapVC = [[FJMapVC alloc]initWithNibName:nil bundle:nil];
    self.fjMapVC.view.frame = self.view.bounds;
    [tabViewItem9 setView:self.fjMapVC.view];

}


@end
