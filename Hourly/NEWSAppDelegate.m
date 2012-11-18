//
//  NEWSAppDelegate.m
//  Hourly
//
//  Created by Zach Williams on 11/15/12.
//  Copyright (c) 2012 Zach Williams. All rights reserved.
//

#import "NEWSAppDelegate.h"
#import "NEWSInitialViewController.h"
#import "NEWSDataModel.h"

@implementation NEWSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Create the shared URL cache
    [[NEWSDataModel sharedModel] createSharedURLCache];
    
    // Root view controller
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[NEWSInitialViewController alloc] init]];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
