//
//  AppDelegate.m
//  DevHandTool
//
//  Created by Bear on 2017/12/20.
//  Copyright © 2017年 Bear. All rights reserved.
//

#import "AppDelegate.h"
#import "FJRootViewController.h"
#import "FJDBManager.h"
#import "FJPasteboardHelper.h"

@interface AppDelegate ()

@property (nonatomic, strong) NSWindowController *rootWindowController;
@property (nonatomic, strong) NSWindow *rootWindow;
@property (nonatomic, strong) FJRootViewController *homeViewController;

@property (weak) IBOutlet NSMenu *menu;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self setupDataBase];
    [self setupPasteboard];
    self.homeViewController = [[FJRootViewController alloc]initWithNibName:@"FJRootViewController" bundle:[NSBundle mainBundle]];
    self.rootWindow = [NSWindow windowWithContentViewController:self.homeViewController];
    [self.rootWindow makeKeyWindow];
    _rootWindow.title = @"DevHandTool";
    
    self.rootWindowController = [[NSWindowController alloc]initWithWindow:self.rootWindow];
    [self.rootWindowController showWindow:nil];
}

- (void)setupDataBase {
    [[FJDBManager defaultManager] createDBIfneeded];
}

- (void)setupPasteboard {
    [[FJPasteboardHelper shared]setupStatueBar:self.menu];
}

@end
