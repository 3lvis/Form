#import "UIViewController+HYPTopViewController.h"

@implementation UIViewController (HYPTopViewController)

+ (UIViewController *)hyp_topViewController {
    UIViewController *topViewController = [UIApplication sharedApplication].keyWindow.rootViewController;

    while (topViewController.presentedViewController) {
        topViewController = topViewController.presentedViewController;
    }

    return topViewController;
}

@end
