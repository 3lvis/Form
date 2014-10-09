//
//  AppDelegate.m

//
//  Created by Elvis Nunez on 03/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "AppDelegate.h"

#import "REMAFielsetsCollectionViewController.h"
#import "REMAFielsetBackgroundView.h"
#import "REMAFielsetsLayout.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    REMAFielsetsLayout *layout = [[REMAFielsetsLayout alloc] init];

    REMAFielsetsCollectionViewController *controllers = [[REMAFielsetsCollectionViewController alloc] initWithCollectionViewLayout:layout];

    self.window.rootViewController = controllers;

    [self.window makeKeyAndVisible];

    return YES;
}

@end