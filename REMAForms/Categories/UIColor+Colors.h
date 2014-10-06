//
//  UIColor+Colors.h
//  Mine Ansatte
//
//  Created by Christoffer Winterkvist on 05/05/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

@import UIKit;

@interface UIColor (Colors)

+ (UIColor *)remaCoreBlue;
+ (UIColor *)remaDarkBlue;
+ (UIColor *)remaCallToAction;
+ (UIColor *)remaCallToActionPressed;
+ (UIColor *)remaBackground;

+ (UIColor *)remaLightGray;
+ (UIColor *)remaDarkGray;

+ (UIColor *)remaFieldForeground;
+ (UIColor *)remaFieldForegroundActive;
+ (UIColor *)remaFieldForegroundInvalid;
+ (UIColor *)remaFieldForegroundDisabled;

+ (UIColor *)remaFieldBackground;
+ (UIColor *)remaFieldBackgroundActive;
+ (UIColor *)remaFieldBackgroundInvalid;
+ (UIColor *)remaFieldBackgroundDisabled;

+ (UIColor *)remaFieldBorder;
+ (UIColor *)remaFieldBorderActive;
+ (UIColor *)remaFieldBorderInvalid;
+ (UIColor *)remaFieldBorderDisabled;

+ (UIColor *)remaBlue;
+ (UIColor *)remaGreen;
+ (UIColor *)remaYellow;
+ (UIColor *)remaRed;

+ (UIColor *)tableCellBackground;
+ (UIColor *)tableCellBorder;
+ (UIColor *)borderColor;
+ (UIColor *)windowBackgroundColor;
+ (UIColor *)navigationForgroundColor;
+ (UIColor *)navigationBackgroundColor;
+ (UIColor *)messageViewForeground;
+ (UIColor *)messageViewBackground;

+ (UIColor *)remaShadowColor;

@end
