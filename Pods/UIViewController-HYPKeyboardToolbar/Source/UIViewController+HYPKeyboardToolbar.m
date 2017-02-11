#import "UIViewController+HYPKeyboardToolbar.h"

@implementation UIViewController (HYPKeyboardToolbar)

#pragma mark - Deallocation

- (void)hyp_removeKeyboardToolbarObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
}

- (void)hyp_addKeyboardToolbarObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

#pragma mark - Notifications

- (void)keyboardWillShow:(NSNotification *)notification
{
    [self keyboardWillToggle:notification];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [self keyboardWillToggle:notification];
}

#pragma mark - Private methods

- (void)keyboardWillToggle:(NSNotification *)notification
{
    CGRect screenRect = [UIScreen mainScreen].bounds;
    CGRect navigationControllerToolbarRect = self.navigationController.toolbar.frame;
    CGFloat initialY = screenRect.size.height - navigationControllerToolbarRect.size.height;

    NSDictionary *userInfo = notification.userInfo;
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;

    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];

    CGFloat navigationControllerToolbarY = initialY - keyboardFrame.size.height;
    if ([notification.name isEqualToString:UIKeyboardWillHideNotification]) {
        navigationControllerToolbarY = initialY;
    }

    CGRect rect = CGRectMake(navigationControllerToolbarRect.origin.x,
                             navigationControllerToolbarY,
                             navigationControllerToolbarRect.size.width,
                             navigationControllerToolbarRect.size.height);

    self.navigationController.toolbar.frame = rect;
}

@end
