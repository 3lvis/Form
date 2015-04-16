#import "FORMFieldValuesTableViewHeader.h"

#import "FORMFieldValueCell.h"

static const CGFloat FORMLabelHeight = 25.0f;

@interface FORMFieldValuesTableViewHeader ()

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *infoLabel;

@end

@implementation FORMFieldValuesTableViewHeader

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;

    [self addSubview:self.titleLabel];
    [self addSubview:self.infoLabel];

    return self;
}

#pragma mark - Getters

- (UILabel *)titleLabel {
    if (_titleLabel) return _titleLabel;

    CGRect rect = CGRectMake(0.0f, 8.0f, FORMFieldValuesHeaderWidth, FORMLabelHeight);

    _titleLabel = [[UILabel alloc] initWithFrame:rect];
    _titleLabel.textAlignment = NSTextAlignmentCenter;

    return _titleLabel;
}

- (UILabel *)infoLabel {
    if (_infoLabel) return _infoLabel;

    CGFloat y = CGRectGetMaxY(self.titleLabel.frame);
    CGRect rect = CGRectMake(0.0f, y, FORMFieldValuesHeaderWidth, FORMLabelHeight);

    _infoLabel = [[UILabel alloc] initWithFrame:rect];
    _infoLabel.textAlignment = NSTextAlignmentCenter;

    return _infoLabel;
}

#pragma mark - Setters

- (void)setField:(FORMField *)field {
    _field = field;

    self.titleLabel.text = field.title;
    self.infoLabel.text = field.info;
}

- (void)setTitleLabelFont:(UIFont *)titleLabelFont {
    self.titleLabel.font = titleLabelFont;
}

- (void)setTitleLabelTextColor:(UIColor *)titleLabelTextColor {
    self.titleLabel.textColor = titleLabelTextColor;
}

- (void)setInfoLabelFont:(UIFont *)infoLabelFont {
    self.infoLabel.font = infoLabelFont;
}

- (void)setInfoLabelTextColor:(UIColor *)infoLabelTextColor {
    self.infoLabel.textColor = infoLabelTextColor;
}

@end
