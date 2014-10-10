//
//  UIScreen+HYPLiveBounds.m

//
//  Created by Christoffer Winterkvist on 6/25/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "UIScreen+HYPLiveBounds.h"

@implementation UIScreen (HYPLiveBounds)

- (CGRect)hyp_liveBounds
{
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];

    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;

    UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if (statusBarOrientation == UIInterfaceOrientationPortrait || statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        orientation = UIDeviceOrientationPortrait;
    } else {
        orientation = UIDeviceOrientationLandscapeLeft;
    }

    BOOL isPortrait = UIDeviceOrientationIsPortrait(orientation);
    CGRect bounds = [self bounds];
    CGFloat width  = bounds.size.width;
    CGFloat height = bounds.size.height;

    if (isPortrait) {
        if (bounds.size.width > height) {
            width  = bounds.size.height;
            height = bounds.size.width;
        }
    } else {
        if (bounds.size.height > bounds.size.width) {
            width  = bounds.size.height;
            height = bounds.size.width;
        }
    }

    bounds.size.width  = width;
    bounds.size.height = height;

    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];

    return bounds;
}

@end
