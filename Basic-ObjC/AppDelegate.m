#import "AppDelegate.h"

#import "HYPSampleCollectionViewController.h"

@import Form;
@import Hex;

#import "NSObject+HYPTesting.h"
#import "NSJSONSerialization+ANDYJSONFile.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
#ifdef DEBUG
    if ([NSObject isUnitTesting]) {
        return YES;
    }
#endif

    [FORMDefaultStyle applyStyle];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    NSDictionary *dictionary = @{@"address" : @"Burger Park 667",
                                 @"end_date" : @"2017-10-31 23:00:00 +00:00",
                                 @"first_name" : @"Ola",
                                 @"last_name" : @"Nordman",
                                 @"start_date" : @"2014-10-31 23:00:00 +00:00",
                                 @"start_time" : @"2014-10-31 23:00:00 +00:00"};

    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"forms.json"];

    HYPSampleCollectionViewController *sampleController = [[HYPSampleCollectionViewController alloc] initWithJSON:JSON
                                                                                                 andInitialValues:dictionary];

    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:sampleController];

    controller.view.tintColor = [[UIColor alloc] initWithHex:@"5182AF"];

    controller.navigationBar.translucent = NO;

    self.window.rootViewController = controller;

    [self.window makeKeyAndVisible];

    return YES;
}

@end
