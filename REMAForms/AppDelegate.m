//
//  AppDelegate.m
//  REMAForms
//
//  Created by Elvis Nunez on 03/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "AppDelegate.h"
#import "REMAFielsetsCollectionViewController.h"
#import "REMAFormsCollectionViewLayout.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    //REMAFormsCollectionViewLayout *layout = [[REMAFormsCollectionViewLayout alloc] init];

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(50.0f, 50.0f);
    layout.sectionInset = UIEdgeInsetsMake(20.0f, 20.0f, 60.0f, 20.0f);
    layout.minimumLineSpacing = 0.0f;
    layout.minimumInteritemSpacing = 0.0f;

    REMAFielsetsCollectionViewController *controllers = [[REMAFielsetsCollectionViewController alloc] initWithCollectionViewLayout:layout];

    self.window.rootViewController = controllers;

    [self.window makeKeyAndVisible];

    return YES;
}

@end