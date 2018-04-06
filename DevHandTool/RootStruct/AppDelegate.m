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
@property (weak) IBOutlet NSMenu *pboardMenu;

@property (nonatomic, strong) NSWindowController *rootWindowController;
@property (nonatomic, strong) NSWindow *rootWindow;
@property (nonatomic, strong) FJRootViewController *homeViewController;
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

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag
{
    if (!flag)
    {
        [_rootWindow makeKeyAndOrderFront:self];
    }
    return YES;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    [[FJPasteboardHelper shared]endService];
}

- (void)setupDataBase {
    [[FJDBManager defaultManager] createDBIfneeded];
}

- (void)setupPasteboard {
    [[FJPasteboardHelper shared]startService:self.pboardMenu];
}

@end
