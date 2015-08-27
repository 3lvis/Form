#import "UIViewController+TopViewController.h"

@implementation UIViewController(TopViewController)

+ (UIViewController *) topViewController {
    UIViewController *topViewController = [UIApplication sharedApplication].keyWindow.rootViewController;

    while (topViewController.presentedViewController) {
        topViewController = topViewController.presentedViewController;
    }

    return topViewController;
}

@end
