//
//  AppDelegate.m
//  REMAForms
//
//  Created by Elvis Nunez on 03/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "AppDelegate.h"
#import "REMAFielsetsCollectionViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(REMAFieldsetMargin, REMAFieldsetMargin, REMAFieldsetMarginBottom, REMAFieldsetMargin);
    layout.minimumLineSpacing = 0.0f;
    layout.minimumInteritemSpacing = 0.0f;

    REMAFielsetsCollectionViewController *controllers = [[REMAFielsetsCollectionViewController alloc] initWithCollectionViewLayout:layout];

    self.window.rootViewController = controllers;

    [self.window makeKeyAndVisible];

    return YES;
}

@end