#import "AppDelegate.h"
#import "FORMDefaultStyle.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [FORMDefaultStyle applyStyle];

    return YES;
}

@end
