#import "HYPTitleLabel.h"

#import "UIColor+ANDYHex.h"
#import "UIFont+REMAStyles.h"
#import "UIColor+REMAColors.h"

static const CGFloat HYPTitleLabelLeftMargin = 10.0f;

@implementation HYPTitleLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = [UIColor colorFromHex:@"3DAFEB"].CGColor;
    self.layer.cornerRadius = 5.0f;
    self.layer.masksToBounds = YES;

    self.backgroundColor = [UIColor colorFromHex:@"E1F5FF"];
    self.font = [UIFont REMATextFieldFont];
    self.textColor = [UIColor colorFromHex:@"455C73"];

    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.userInteractionEnabled = YES;

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleLabelTapAction)];
    [self addGestureRecognizer:tapGestureRecognizer];

    return self;
}

- (void)drawTextInRect:(CGRect)rect
{
    UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, HYPTitleLabelLeftMargin, 0.0f, 0.0f);

    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
    UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, HYPTitleLabelLeftMargin, 0.0f, 0.0f);

    CGRect frame = UIEdgeInsetsInsetRect(bounds, insets);

    return CGRectInset(frame, HYPTitleLabelLeftMargin, 0.0f);
}

- (void)setActive:(BOOL)active
{
    _active = active;

    if (active) {
        self.backgroundColor = [UIColor colorFromHex:@"C0EAFF"];
        self.layer.borderColor = [UIColor colorFromHex:@"3DAFEB"].CGColor;
    } else {
        self.backgroundColor = [UIColor colorFromHex:@"E1F5FF"];
        self.layer.borderColor = [UIColor colorFromHex:@"3DAFEB"].CGColor;
    }
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];

    if (enabled) {
        self.backgroundColor = [UIColor colorFromHex:@"E1F5FF"];
        self.layer.borderColor = [UIColor colorFromHex:@"3DAFEB"].CGColor;
    } else {
        self.backgroundColor = [UIColor colorFromHex:@"F5F5F8"];
        self.layer.borderColor = [UIColor colorFromHex:@"DEDEDE"].CGColor;
    }
}

- (void)setValid:(BOOL)valid
{
    _valid = valid;

    if (!self.isEnabled) return;

    if (valid) {
        self.backgroundColor = [UIColor colorFromHex:@"E1F5FF"];
        self.layer.borderColor = [UIColor colorFromHex:@"3DAFEB"].CGColor;
    } else {
        self.backgroundColor = [UIColor REMAFieldBackgroundInvalid];
        self.layer.borderColor = [UIColor colorFromHex:@"EC3031"].CGColor;
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
