#import "FORMFieldValueLabel.h"

#import "FORMBaseFieldCell.h"

static UIColor *activeBackgroundColor;
static UIColor *activeBorderColor;
static UIColor *inactiveBackgroundColor;
static UIColor *inactiveBorderColor;

static UIColor *enabledBackgroundColor;
static UIColor *enabledBorderColor;
static UIColor *disabledBackgroundColor;
static UIColor *disabledBorderColor;

static UIColor *validBackgroundColor;
static UIColor *validBorderColor;
static UIColor *invalidBackgroundColor;
static UIColor *invalidBorderColor;

static BOOL enabledProperty;

@interface FORMFieldValueLabel ()

@end

@implementation FORMFieldValueLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    self.layer.masksToBounds = YES;

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
        self.backgroundColor = activeBackgroundColor;
        self.layer.borderColor = activeBorderColor.CGColor;
    } else {
        self.backgroundColor = inactiveBackgroundColor;
        self.layer.borderColor = inactiveBorderColor.CGColor;
    }
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];

    enabledProperty = enabled;

    if (enabled) {
        self.backgroundColor = enabledBackgroundColor;
        self.layer.borderColor = enabledBorderColor.CGColor;
    } else {
        self.backgroundColor = inactiveBackgroundColor;
        self.layer.borderColor = inactiveBorderColor.CGColor;
    }
}

- (void)setValid:(BOOL)valid
{
    _valid = valid;

    if (!self.isEnabled) return;

    if (valid) {
        self.backgroundColor = validBackgroundColor;
        self.layer.borderColor = validBorderColor.CGColor;
    } else {
        self.backgroundColor = invalidBackgroundColor;
        self.layer.borderColor = invalidBorderColor.CGColor;
    }
}

#pragma mark - Actions

- (void)titleLabelTapAction
{
    if ([self.delegate respondsToSelector:@selector(titleLabelPressed:)]) {
        [self.delegate titleLabelPressed:self];
    }
}

#pragma mark - Appearance

- (void)setBorderWidth:(CGFloat)borderWidth
{
    self.layer.borderWidth = borderWidth;
}

- (void)setBorderColor:(UIColor *)borderColor
{
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
}

- (void)setActiveBackgroundColor:(UIColor *)color
{
    activeBackgroundColor = color;
}

- (void)setActiveBorderColor:(UIColor *)color
{
    activeBorderColor = color;
}

- (void)setInactiveBackgroundColor:(UIColor *)color
{
    inactiveBackgroundColor = color;
}

- (void)setInactiveBorderColor:(UIColor *)color
{
    inactiveBorderColor = color;
}

- (void)setEnabledBackgroundColor:(UIColor *)color
{
    enabledBackgroundColor = color;
}

- (void)setEnabledBorderColor:(UIColor *)color
{
    enabledBorderColor = color;
}

- (void)setDisabledBackgroundColor:(UIColor *)color
{
    disabledBackgroundColor = color;
}

- (void)setDisabledBorderColor:(UIColor *)color
{
    disabledBorderColor = color;
}

- (void)setValidBackgroundColor:(UIColor *)color
{
    validBackgroundColor = color;
}

- (void)setValidBorderColor:(UIColor *)color
{
    validBorderColor = color;
}

- (void)setInvalidBackgroundColor:(UIColor *)color
{
    invalidBackgroundColor = color;
}

- (void)setInvalidBorderColor:(UIColor *)color
{
    invalidBorderColor = color;
    self.enabled = enabledProperty;
}

@end
