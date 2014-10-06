//
//  NSString+ANDYSizes.h
//
//  Created by Elvis Nunez on 4/24/14.
//  Copyright (c) 2014 Elvis Nunez. All rights reserved.
//

@import CoreGraphics;
@import Foundation;
@import UIKit;

@interface NSString (ANDYSizes)

+ (CGFloat)heightForString:(NSString *)string width:(CGFloat)width font:(UIFont *)font;
+ (CGFloat)heightForString:(NSString *)string font:(UIFont *)font;
+ (CGFloat)widthForString:(NSString *)string font:(UIFont *)font;

@end
