#import "FORMFieldValueLabel.h"

#import "FORMBaseFieldCell.h"

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
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
}

- (void)setValid:(BOOL)valid
{
    _valid = valid;

    if (!self.isEnabled) return;
}

#pragma mark - Actions

- (void)titleLabelTapAction
{
    if ([self.delegate respondsToSelector:@selector(titleLabelPressed:)]) {
        [self.delegate titleLabelPressed:self];
    }
}

@end
