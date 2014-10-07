//
//  REMABaseField.m

//
//  Created by Christoffer Winterkvist on 7/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "REMABaseField.h"

#import "UIFont+Styles.h"
#import "UIColor+Colors.h"

@implementation REMABaseField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    self.backgroundColor = [UIColor clearColor];
    self.valid = YES;
    [self addSubview:self.label];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];

    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter  defaultCenter] removeObserver:self
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
}

#pragma mark - Getters

- (UILabel *)label
{
    if (_label) return _label;

    CGRect labelFrame = self.frame;
    labelFrame.origin.y = -32.f;
    labelFrame.origin.x = 6.f;

    _label = [[UILabel alloc] initWithFrame:labelFrame];
    _label.font = [UIFont REMALabelFont];
    _label.textColor = [UIColor remaCoreBlue];

    return _label;
}

- (UIImageView *)iconImageView
{
    if (_iconImageView) return _iconImageView;

    CGRect frame = CGRectMake(0.0f, 0.0f, 38.0f, 45.0f);
    _iconImageView = [[UIImageView alloc] initWithFrame:frame];
    _iconImageView.contentMode = UIViewContentModeCenter;
    [self addSubview:_iconImageView];

    return _iconImageView;
}

- (BOOL)isInvalid
{
    return !self.isValid;
}

#pragma mark - Private methods

- (void)orientationChanged:(NSNotification *)notification
{
    [self setNeedsDisplay];
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    CGRect drawingRect = CGRectMake(rect.origin.x + 0.5,
                                    rect.origin.y + 0.5,
                                    rect.size.width - 1.0,
                                    rect.size.height - 1.0);

    if (self.cornerType == REMATextFieldCornerTop ||
        self.cornerType == REMATextFieldCornerBottom) {
        drawingRect = CGRectMake(rect.origin.x + 0.5,
                                 rect.origin.y + 0.5,
                                 rect.size.width - 1.0,
                                 44.0f - 0.5);
    }

    if (self.isAlternative) {
        drawingRect = CGRectMake(rect.origin.x + 5.0f,
                                 rect.origin.y + 30.0f,
                                 rect.size.width - 10.0f,
                                 rect.size.height - 55.0f);
    }

    UIRectCorner corners;
    if (self.cornerType == REMATextFieldCornerTop) {
        corners = UIRectCornerTopLeft | UIRectCornerTopRight;
    } else if (self.cornerType == REMATextFieldCornerBottom) {
        corners = UIRectCornerBottomLeft | UIRectCornerBottomRight;
    } else {
        corners = UIRectCornerAllCorners;
    }

    UIBezierPath *rectanglePath = [UIBezierPath bezierPathWithRoundedRect:drawingRect
                                                        byRoundingCorners:corners
                                                              cornerRadii:CGSizeMake(5.0f, 5.0f)];
    [rectanglePath closePath];

    [[self evaluatedBackgroundColor] setFill];
    [rectanglePath fill];

    [[self evaluatedBorderColor] setStroke];
    rectanglePath.lineWidth = 1;
    [rectanglePath stroke];

    [self evaluateIcons];
}

- (UIColor *)evaluatedBackgroundColor
{
    if (self.isDisabled) {
        return [UIColor remaFieldBackgroundDisabled];
    }

    UIColor *backgroundColor;
    if (self.isFailed) {
        backgroundColor = [UIColor remaFieldBackgroundInvalid];
    } else {
        if (self.isValid) {
            backgroundColor = (self.isActive) ? [UIColor remaFieldBackgroundActive] : [UIColor remaFieldBackground];
        } else {
            backgroundColor = [UIColor remaFieldBackgroundInvalid];
        }
    }
    return backgroundColor;
}

- (UIColor *)evaluatedBorderColor
{
    if (self.isDisabled) {
        return [UIColor remaFieldBorderDisabled];
    }

    UIColor *borderColor;
    if (self.isFailed) {
        borderColor = [UIColor remaFieldBorderInvalid];
    } else {
        if (self.isValid) {
            borderColor = (self.active) ? [UIColor remaFieldBorderActive] : [UIColor remaFieldBorder];
        } else {
            borderColor = [UIColor remaFieldBorderInvalid];
        }
    }
    return borderColor;
}

- (void)evaluateIcons
{
    UIImage *image;

    if (self.isDisabled) {
        image = self.disabledIcon;
    } else {
        image = (self.isFailed || self.isInvalid) ? self.invalidIcon : self.validIcon;
    }

    if (image) {
        self.iconImageView.image = image;
    }
}

#pragma mark - Setters

- (void)setDisabled:(BOOL)disabled
{
    _disabled = disabled;

    if (disabled && self.disabledIcon) {
        self.iconImageView.image = self.disabledIcon;
    }

    [self setNeedsDisplay];
}

- (void)setFailed:(BOOL)failed
{
    _failed = failed;
}

- (void)setActive:(BOOL)active
{
    _active = active;
    [self setNeedsDisplay];
}

- (void)setCollapsed:(BOOL)collapsed
{
    _collapsed = collapsed;
    [self setNeedsDisplay];
}

- (void)setAlternative:(BOOL)alternative
{
    _alternative = alternative;
    [self setNeedsDisplay];
}

#pragma mark - Validations

- (void)validate
{
    NSLog(@"no validation was provided");
}

@end
