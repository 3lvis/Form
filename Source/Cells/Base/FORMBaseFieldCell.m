#import "FORMBaseFieldCell.h"

static const CGFloat HYPTextFormFieldCellLabelMarginTop = 10.0f;
static const CGFloat HYPTextFormFieldCellLabelHeight = 20.0f;
static const CGFloat HYPTextFormFieldCellLabelMarginX = 5.0f;

@interface FORMBaseFieldCell ()

@property (nonatomic, strong) UIView *separatorView;

@end

@implementation FORMBaseFieldCell

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    [self.contentView addSubview:self.headingLabel];
    [self.contentView addSubview:self.separatorView];

    return self;
}

#pragma mark - Getters

- (FORMFieldHeadingLabel *)headingLabel
{
    if (_headingLabel) return _headingLabel;

    _headingLabel = [[FORMFieldHeadingLabel alloc] initWithFrame:[self headingLabelFrame]];

    return _headingLabel;
}

- (UIView *)separatorView
{
    if (_separatorView) return _separatorView;

    _separatorView = [[UIView alloc] initWithFrame:[self separatorViewFrame]];

#warning needs custom style
    // _separatorView.backgroundColor = [UIColor HYPFormsFieldBorderDisabled];

    return _separatorView;
}

#pragma mark - Setters

- (void)setDisabled:(BOOL)disabled
{
    _disabled = disabled;

    [self updateFieldWithDisabled:disabled];
}

- (void)setField:(FORMField *)field
{
    _field = field;

    [self updateWithField:field];
}

#pragma mark - Overwritables

- (void)updateFieldWithDisabled:(BOOL)disabled
{
    abort();
}

- (void)updateWithField:(FORMField *)field
{
    self.headingLabel.hidden = (field.sectionSeparator);
    self.headingLabel.text = field.title;

    self.separatorView.hidden = !field.sectionSeparator;

    if (field.targets.count > 0) {
        if ([self.delegate respondsToSelector:@selector(fieldCell:processTargets:)]) {
            [self.delegate fieldCell:self processTargets:field.targets];
        }
    }
}

- (void)validate
{
    NSLog(@"validation in progress");
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.headingLabel.frame = [self headingLabelFrame];

    self.separatorView.frame = [self separatorViewFrame];
}

- (CGRect)headingLabelFrame
{
    CGFloat marginX = FORMTextFieldCellMarginX + HYPTextFormFieldCellLabelMarginX;
    CGFloat marginTop = HYPTextFormFieldCellLabelMarginTop;

    CGFloat width = CGRectGetWidth(self.frame) - (marginX * 2);
    CGFloat height = HYPTextFormFieldCellLabelHeight;
    CGRect frame = CGRectMake(marginX, marginTop, width, height);

    return frame;
}

- (CGRect)separatorViewFrame
{
    CGRect frame = self.frame;
    frame.origin.x = 0.0f;
    frame.origin.y = CGRectGetHeight(frame) - 1.0f;
    frame.size.height = 1.0f;

    return frame;
}

@end
