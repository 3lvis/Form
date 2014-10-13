//
//  UIColor+Colors.h

//
//  Created by Christoffer Winterkvist on 05/05/14.
//  Copyright (c) 2014 REMAer. All rights reserved.
//

@import UIKit;

@interface UIColor (REMAColors)

+ (UIColor *)REMACoreBlue;
+ (UIColor *)REMADarkBlue;
+ (UIColor *)REMACallToAction;
+ (UIColor *)REMACallToActionPressed;
+ (UIColor *)REMABackground;

+ (UIColor *)REMALightGray;
+ (UIColor *)REMADarkGray;

+ (UIColor *)REMAFieldForeground;
+ (UIColor *)REMAFieldForegroundActive;
+ (UIColor *)REMAFieldForegroundInvalid;
+ (UIColor *)REMAFieldForegroundDisabled;

+ (UIColor *)REMAFieldBackground;
+ (UIColor *)REMAFieldBackgroundActive;
+ (UIColor *)REMAFieldBackgroundInvalid;
+ (UIColor *)REMAFieldBackgroundDisabled;

+ (UIColor *)REMAFieldBorder;
+ (UIColor *)REMAFieldBorderActive;
+ (UIColor *)REMAFieldBorderInvalid;
+ (UIColor *)REMAFieldBorderDisabled;

+ (UIColor *)REMABlue;
+ (UIColor *)REMAGreen;
+ (UIColor *)REMAYellow;
+ (UIColor *)REMARed;

+ (UIColor *)tableCellBackground;
+ (UIColor *)tableCellBorder;
+ (UIColor *)borderColor;
+ (UIColor *)windowBackgroundColor;
+ (UIColor *)navigationForgroundColor;
+ (UIColor *)navigationBackgroundColor;
+ (UIColor *)messageViewForeground;
+ (UIColor *)messageViewBackground;

+ (UIColor *)REMAShadowColor;

@end
