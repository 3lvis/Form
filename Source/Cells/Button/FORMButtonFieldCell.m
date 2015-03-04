#import "FORMButtonFieldCell.h"

#import "UIButton+ANDYHighlighted.h"

@interface FORMButtonFieldCell ()

@property (nonatomic, strong) UIButton *button;

@end

@implementation FORMButtonFieldCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    [self.contentView addSubview:self.button];
    self.headingLabel.hidden = YES;

    return self;
}

#pragma mark - Getters

- (UIButton *)button
{
    if (_button) return _button;

    _button = [UIButton buttonWithType:UIButtonTypeCustom];

    #warning needs custom style
//    _button.titleLabel.font = [UIFont HYPFormsActionButtonFont];

    _button.layer.borderWidth = 1.0f;
    _button.layer.cornerRadius = 5.0f;

    _button.titleColor = [UIColor whiteColor];
    #warning needs custom style
//    _button.highlightedTitleColor = [UIColor HYPFormsCallToAction];
//    _button.layer.borderColor = [UIColor HYPFormsCallToAction].CGColor;

    #warning needs custom style
//    _button.backgroundColor = [UIColor HYPFormsCallToAction];
    _button.highlightedBackgroundColor = [UIColor whiteColor];

    [_button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];

    return _button;
}

#pragma mark - FORMBaseFormFieldCell

- (void)updateFieldWithDisabled:(BOOL)disabled
{
    self.button.alpha = disabled ? 0.5f : 1.0f;
    self.button.enabled = disabled ? NO : YES;
}

- (void)updateWithField:(FORMField *)field
{
    [super updateWithField:field];

    self.button.enabled = !field.disabled;
    self.disabled = field.disabled;
    self.headingLabel.hidden = YES;

    [self.button setTitle:field.title forState:UIControlStateNormal];
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.button.frame = [self buttonFrame];
}

- (CGRect)buttonFrame
{
    CGFloat marginX = FORMTextFieldCellMarginX;
    CGFloat marginTop = FORMFieldCellMarginTop;
    CGFloat marginBotton = FORMFieldCellMarginBottom;

    CGFloat width  = CGRectGetWidth(self.frame) - (marginX * 2);
    CGFloat height = CGRectGetHeight(self.frame) - marginTop - marginBotton;
    CGRect  frame  = CGRectMake(marginX, marginTop, width, height);

    return frame;
}

#pragma mark - Actions

- (void)buttonAction
{
    if ([self.delegate respondsToSelector:@selector(fieldCell:updatedWithField:)]) {
        [self.delegate fieldCell:self updatedWithField:self.field];
    }
}

@end
