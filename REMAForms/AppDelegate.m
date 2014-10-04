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
    layout.estimatedItemSize = CGSizeMake(100.0f, 60.0f);
//    
//    layout.itemSize = CGSizeMake(50.0f, 50.0f);
//    layout.minimumLineSpacing = 5.0f;
//    layout.minimumInteritemSpacing = 5.0f;
//    layout.sectionInset = UIEdgeInsetsMake(20.0f, 10.0f, 20.0f, 10.0f);

//    @property (nonatomic) CGFloat minimumLineSpacing;
//    @property (nonatomic) CGFloat minimumInteritemSpacing;
//    @property (nonatomic) CGSize estimatedItemSize NS_AVAILABLE_IOS(8_0); // defaults to CGSizeZero - setting a non-zero size enables cells that self-size via -perferredLayoutAttributesFittingAttributes:
//    @property (nonatomic) UICollectionViewScrollDirection scrollDirection; // default is UICollectionViewScrollDirectionVertical
//    @property (nonatomic) CGSize headerReferenceSize;
//    @property (nonatomic) CGSize footerReferenceSize;
//    @property (nonatomic) UIEdgeInsets sectionInset;

    REMAFielsetsCollectionViewController *controllers = [[REMAFielsetsCollectionViewController alloc] initWithCollectionViewLayout:nil];
    self.window.rootViewController = controllers;

    [self.window makeKeyAndVisible];

    return YES;
}

@end