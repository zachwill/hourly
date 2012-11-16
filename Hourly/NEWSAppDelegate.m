//
//  NEWSAppDelegate.m
//  Hourly
//
//  Created by Zach Williams on 11/15/12.
//  Copyright (c) 2012 Zach Williams. All rights reserved.
//

#import "NEWSAppDelegate.h"
#import "NEWSInitialViewController.h"

@implementation NEWSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[NEWSInitialViewController alloc] init];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
