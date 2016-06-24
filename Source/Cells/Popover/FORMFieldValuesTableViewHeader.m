#import "FORMFieldValuesTableViewHeader.h"

#import "FORMFieldValueCell.h"

@interface FORMFieldValuesTableViewHeader ()

@property (nonatomic) UILabel *infoLabel;

@end

@implementation FORMFieldValuesTableViewHeader

#pragma mark - Initializers

- (instancetype)initWithReuseIdentifier:(NSString *)string {
    self = [super initWithReuseIdentifier:string];
    if (!self) return nil;

    [self addSubview:self.infoLabel];

    return self;
}

#pragma mark - Getters

- (CGRect)infoLabelFrame {
    CGFloat x = 0;
    CGFloat width = FORMFieldValuesHeaderWidth;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        CGRect bounds = [[UIScreen mainScreen] bounds];
        width = bounds.size.width;
        x = (width - FORMFieldValuesHeaderWidth) / 2.0;
    }
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
    height += self.infoLabel.frame.size.height;

    return height;
}

#pragma mark - Setters

- (void)setField:(FORMField *)field {
    _field = field;

    self.infoLabel.text = field.info;

    [self updateLabelFrames];
}

- (void)setInfoLabelFont:(UIFont *)infoLabelFont {
    self.infoLabel.font = infoLabelFont;
}

- (void)setInfoLabelTextColor:(UIColor *)infoLabelTextColor {
    self.infoLabel.textColor = infoLabelTextColor;
}

#pragma marks - Private methods

- (void)updateLabelFrames {
    [self.infoLabel sizeToFit];
    CGRect infoFrame = self.infoLabel.frame;
    infoFrame.origin.y = [self infoLabelFrame].origin.y;
    infoFrame.size.width = FORMFieldValuesHeaderWidth;
    infoFrame.size.height = self.infoLabel.frame.size.height + 10.0;
    self.infoLabel.frame = infoFrame;
}

@end
