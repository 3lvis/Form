#import "AppDelegate.h"
#import "FORMDefaultStyle.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [FORMDefaultStyle applyStyle];

    return YES;
}

@end
