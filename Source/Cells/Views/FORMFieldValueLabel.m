#import "FORMFieldValueLabel.h"

#import "FORMBaseFieldCell.h"

#import "UIColor+ANDYHex.h"
#import "UIFont+HYPFormsStyles.h"
#import "UIColor+HYPFormsColors.h"

@implementation FORMFieldValueLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    self.layer.borderWidth = FORMFieldCellBorderWidth;
    self.layer.borderColor = [UIColor HYPFormsBlue].CGColor;
    self.layer.cornerRadius = FORMFieldCellCornerRadius;
    self.layer.masksToBounds = YES;

    self.backgroundColor = [UIColor HYPFormsFieldBackground];
    self.font = [UIFont HYPFormsTextFieldFont];
    self.textColor = [UIColor HYPFormsDarkBlue];

    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.userInteractionEnabled = YES;

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleLabelTapAction)];
    [self addGestureRecognizer:tapGestureRecognizer];

    return self;
}

- (void)drawTextInRect:(CGRect)rect
{
    UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, FORMFieldCellLeftMargin, 0.0f, 0.0f);

    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
    UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, FORMFieldCellLeftMargin, 0.0f, 0.0f);

    CGRect frame = UIEdgeInsetsInsetRect(bounds, insets);

    return CGRectInset(frame, FORMFieldCellLeftMargin, 0.0f);
}

- (void)setActive:(BOOL)active
{
    _active = active;

    if (active) {
        self.backgroundColor = [UIColor HYPFormsFieldBackgroundActive];
        self.layer.borderColor = [UIColor HYPFormsBlue].CGColor;
    } else {
        self.backgroundColor = [UIColor HYPFormsFieldBackground];
        self.layer.borderColor = [UIColor HYPFormsBlue].CGColor;
    }
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];

    if (enabled) {
        self.backgroundColor = [UIColor HYPFormsFieldBackground];
        self.layer.borderColor = [UIColor HYPFormsBlue].CGColor;
    } else {
        self.backgroundColor = [UIColor HYPFormsLightGray];
        self.layer.borderColor = [UIColor HYPFormsFieldDisabledText].CGColor;
    }
}

- (void)setValid:(BOOL)valid
{
    _valid = valid;

    if (!self.isEnabled) return;

    if (valid) {
        self.backgroundColor = [UIColor HYPFormsFieldBackground];
        self.layer.borderColor = [UIColor HYPFormsBlue].CGColor;
    } else {
        self.backgroundColor = [UIColor HYPFormsFieldBackgroundInvalid];
        self.layer.borderColor = [UIColor HYPFormsRed].CGColor;
    }
}

#pragma mark - Actions

- (void)titleLabelTapAction
{
    if ([self.delegate respondsToSelector:@selector(titleLabelPressed:)]) {
        [self.delegate titleLabelPressed:self];
    }
}

@end
