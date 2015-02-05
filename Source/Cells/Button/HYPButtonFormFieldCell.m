#import "HYPButtonFormFieldCell.h"

#import "UIColor+HYPFormsColors.h"

#import "UIButton+ANDYHighlighted.h"

@interface HYPButtonFormFieldCell ()

@property (nonatomic, strong) UIButton *button;

@end

@implementation HYPButtonFormFieldCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    [self.contentView addSubview:self.button];

    return self;
}

#pragma mark - Getters

- (UIButton *)button
{
    if (_button) return _button;

    _button = [UIButton buttonWithType:UIButtonTypeCustom];

    _button.layer.borderColor = [UIColor HYPFormsCoreBlue].CGColor;
    _button.layer.borderWidth = 1.0f;
    _button.layer.cornerRadius = 5.0f;

    [_button setTitle:@"Hola" forState:UIControlStateNormal];

    _button.titleColor = [UIColor HYPFormsCoreBlue];
    _button.highlightedTitleColor = [UIColor whiteColor];

    _button.backgroundColor = [UIColor whiteColor];
    _button.highlightedBackgroundColor = [UIColor HYPFormsCoreBlue];

    return _button;
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.button.frame = [self buttonFrame];
}

- (CGRect)buttonFrame
{
    CGFloat marginX = HYPTextFormFieldCellMarginX;
    CGFloat marginTop = HYPFormFieldCellMarginTop;
    CGFloat marginBotton = HYPFormFieldCellMarginBottom;

    CGFloat width  = CGRectGetWidth(self.frame) - (marginX * 2);
    CGFloat height = CGRectGetHeight(self.frame) - marginTop - marginBotton;
    CGRect  frame  = CGRectMake(marginX, marginTop, width, height);

    return frame;
}

@end
