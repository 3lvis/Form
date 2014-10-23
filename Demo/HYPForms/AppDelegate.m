//
//  AppDelegate.m

//
//  Created by Elvis Nunez on 03/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "AppDelegate.h"

#import "HYPSampleCollectionViewController.h"
#import "HYPFormBackgroundView.h"
#import "HYPFormsLayout.h"
#import "UIColor+ANDYHex.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    NSDictionary *dictionary = @{ @"address" : @"Burger Park 667",
                                  @"bank_account_number" : @"11111111111",
                                  @"email_address" : @"christoffer@hyper.no",
                                  @"end_date" : @"2017-10-31 23:00:00 +00:00",
                                  @"first_name" : @"Chris",
                                  @"hours_per_week" : @"37,5",
                                  @"last_name" : @"Winterkvist",
                                  @"phone_number" : @"41399880",
                                  @"postal_code" : @"6414",
                                  @"social_security_number" : @"28118240000",
                                  @"start_date" : @"2014-10-31 23:00:00 +00:00",
                                  @"worker_id" : @"120000",
                                  @"employment_type" : @1,
                                  @"employment_percent" : @"100",
                                  @"fixed_pay_premium_percent" : @"10",
                                  @"fixed_pay_premium_currency" : @"10",
                                  @"salary_type" : @2,
                                  @"fixed_pay_level" : @4,
                                  @"position" : @3,
                                  @"city" : @"HALDEN",
                                  @"country_code" : @"NO"
                                  };

    HYPSampleCollectionViewController *sampleController = [[HYPSampleCollectionViewController alloc] initWithDictionary:dictionary];

    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:sampleController];
    controller.view.tintColor = [UIColor colorFromHex:@"5182AF"];
    controller.navigationBarHidden = YES;

    self.window.rootViewController = controller;

    [self.window makeKeyAndVisible];

    return YES;
}

@end
