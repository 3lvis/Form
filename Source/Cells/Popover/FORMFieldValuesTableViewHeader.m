#import "FORMFieldValuesTableViewHeader.h"

#import "FORMFieldValueCell.h"

static const CGFloat FORMLabelHeight = 25.0f;

@interface FORMFieldValuesTableViewHeader ()

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *subtitleLabel;

@end

@implementation FORMFieldValuesTableViewHeader

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    [self addSubview:self.titleLabel];
    [self addSubview:self.subtitleLabel];

    return self;
}

#pragma mark - Getters

- (UILabel *)titleLabel
{
    if (_titleLabel) return _titleLabel;

    CGRect rect = CGRectMake(0.0f, 8.0f, FORMFieldValuesHeaderWidth, FORMLabelHeight);

    _titleLabel = [[UILabel alloc] initWithFrame:rect];
    _titleLabel.textAlignment = NSTextAlignmentCenter;

    return _titleLabel;
}

- (UILabel *)subtitleLabel
{
    if (_subtitleLabel) return _subtitleLabel;

    CGFloat y = CGRectGetMaxY(self.titleLabel.frame);
    CGRect rect = CGRectMake(0.0f, y, FORMFieldValuesHeaderWidth, FORMLabelHeight);

    _subtitleLabel = [[UILabel alloc] initWithFrame:rect];
    _subtitleLabel.textAlignment = NSTextAlignmentCenter;

    return _subtitleLabel;
}

#pragma mark - Setters

- (void)setField:(FORMField *)field
{
    _field = field;

    self.titleLabel.text = field.title;
    self.subtitleLabel.text = field.subtitle;
}

- (void)setTitleLabelFont:(UIFont *)titleLabelFont
{
    self.titleLabel.font = titleLabelFont;
}

- (void)setTitleLabelTextColor:(UIColor *)titleLabelTextColor
{
    self.titleLabel.textColor = titleLabelTextColor;
}

- (void)setSubtitleLabelFont:(UIFont *)subtitleLabelFont
{
    self.subtitleLabel.font = subtitleLabelFont;
}

- (void)setSubtitleLabelTextColor:(UIColor *)subtitleLabelTextColor
{
    self.subtitleLabel.textColor = subtitleLabelTextColor;
}

@end
