#import "FORMFieldValuesTableViewHeader.h"

#import "FORMFieldValueCell.h"

@interface FORMFieldValuesTableViewHeader ()

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *infoLabel;

@end

@implementation FORMFieldValuesTableViewHeader

#pragma mark - Initializers

- (instancetype)initWithReuseIdentifier:(NSString *)string {
    self = [super initWithReuseIdentifier:string];
    if (!self) return nil;

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self addSubview:self.titleLabel];
    }

    [self addSubview:self.infoLabel];

    return self;
}

#pragma mark - Getters
- (CGRect)titleLabelFrame {
    return CGRectMake(0.0f, FORMInfoLabelY, FORMFieldValuesHeaderWidth, FORMLabelHeight);
}

- (UILabel *)titleLabel {
    if (_titleLabel) return _titleLabel;

    _titleLabel = [[UILabel alloc] initWithFrame:[self titleLabelFrame]];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    _titleLabel.numberOfLines = 0;
    _titleLabel.text = self.field.title;

    return _titleLabel;
}

- (CGRect)infoLabelFrame {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        CGFloat y = CGRectGetMaxY(self.titleLabel.frame);
        return CGRectMake(0.0f, y, FORMFieldValuesHeaderWidth, FORMLabelHeight * 1.1);
    }

    CGFloat x = 0;
    CGFloat width = FORMFieldValuesHeaderWidth;
    CGRect bounds = [[UIScreen mainScreen] bounds];
    width = bounds.size.width;
    x = (width - FORMFieldValuesHeaderWidth) / 2.0;

    return CGRectMake(x, FORMInfoLabelY, width, FORMLabelHeight * 1.1);
}

- (UILabel *)infoLabel {
    if (_infoLabel) return _infoLabel;

    _infoLabel = [[UILabel alloc] initWithFrame:[self infoLabelFrame]];
    _infoLabel.textAlignment = NSTextAlignmentCenter;
    _infoLabel.numberOfLines = 0;
    _infoLabel.text = self.field.info;

    return _infoLabel;
}

- (CGFloat)labelHeight
{
    CGFloat height = 0.0f;

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        height += self.titleLabel.frame.origin.y * 2;
        height += self.titleLabel.frame.size.height;
    }

    height += self.infoLabel.frame.size.height;

    return height;
}

#pragma mark - Setters

- (void)setField:(FORMField *)field {
    _field = field;

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.titleLabel.text = field.title;
    }

    self.infoLabel.text = field.info;

    [self updateLabelFrames];
}

- (void)setTitleLabelFont:(UIFont *)titleLabelFont {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.titleLabel.font = titleLabelFont;
    }
}

- (void)setTitleLabelTextColor:(UIColor *)titleLabelTextColor {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.titleLabel.textColor = titleLabelTextColor;
    }
}

- (void)setInfoLabelFont:(UIFont *)infoLabelFont {
    self.infoLabel.font = infoLabelFont;
}

- (void)setInfoLabelTextColor:(UIColor *)infoLabelTextColor {
    self.infoLabel.textColor = infoLabelTextColor;
}

#pragma marks - Private methods

- (void)updateLabelFrames {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self.titleLabel sizeToFit];
        CGRect titleFrame = self.titleLabel.frame;
        titleFrame.size.width = FORMFieldValuesHeaderWidth;
        self.titleLabel.frame = titleFrame;
    }

    [self.infoLabel sizeToFit];
    CGRect infoFrame = self.infoLabel.frame;
    infoFrame.origin.y = [self infoLabelFrame].origin.y;
    infoFrame.size.width = FORMFieldValuesHeaderWidth;
    infoFrame.size.height = self.infoLabel.frame.size.height + 10.0;

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        infoFrame.size.height = self.infoLabel.frame.size.height + 10.0;
    }
    
    self.infoLabel.frame = infoFrame;
}

@end
