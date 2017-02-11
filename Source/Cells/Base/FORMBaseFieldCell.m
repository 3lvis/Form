#import "FORMBaseFieldCell.h"

#import "FORMSeparatorView.h"

#import "UIColor+Hex.h"

static NSString * const FORMHideTooltips = @"FORMHideTooltips";
static const CGFloat FORMTextFormFieldCellLabelMarginTop = 10.0f;
static const CGFloat FORMTextFormFieldCellLabelHeight = 20.0f;
static const CGFloat FORMTextFormFieldCellLabelMarginX = 5.0f;

static NSString * const FORMHeadingLabelFontKey = @"heading_label_font";
static NSString * const FORMHeadingLabelFontSizeKey = @"heading_label_font_size";
static NSString * const FORMHeadingLabelTextColorKey = @"heading_label_text_color";

@interface FORMBaseFieldCell ()

@property (nonatomic) FORMSeparatorView *separatorView;

@end

@implementation FORMBaseFieldCell

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;

    [self.contentView addSubview:self.headingLabel];
    [self.contentView addSubview:self.separatorView];

    return self;
}

#pragma mark - Getters

- (UILabel *)headingLabel {
    if (_headingLabel) return _headingLabel;

    _headingLabel = [[UILabel alloc] initWithFrame:[self headingLabelFrame]];

    return _headingLabel;
}

- (FORMSeparatorView *)separatorView {
    if (_separatorView) return _separatorView;

    _separatorView = [[FORMSeparatorView alloc] initWithFrame:[self separatorViewFrame]];
    _separatorView.hidden = YES;

    return _separatorView;
}

#pragma mark - Setters

- (void)setDisabled:(BOOL)disabled {
    _disabled = disabled;

    [[NSNotificationCenter defaultCenter] postNotificationName:FORMHideTooltips
                                                        object:@(!disabled)];

    [self updateFieldWithDisabled:disabled];
}

- (void)setField:(FORMField *)field {
    _field = field;

    [self updateWithField:field];
}

#pragma mark - Overwritables

- (void)updateFieldWithDisabled:(BOOL)disabled {
    abort();
}

- (void)updateWithField:(FORMField *)field {
    self.headingLabel.hidden = (field.sectionSeparator);
    self.headingLabel.text = field.title;
    self.styles = field.styles;

    if (field.sectionSeparator) {
        self.separatorView.styles = field.styles;
    }
    
    self.separatorView.hidden = !field.sectionSeparator;

    if (field.targets.count > 0) {
        if ([self.delegate respondsToSelector:@selector(fieldCell:processTargets:)]) {
            [self.delegate fieldCell:self processTargets:field.targets];
        }
    }
}

- (void)validate {
    NSLog(@"validation in progress");
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];

    self.headingLabel.frame = [self headingLabelFrame];

    self.separatorView.frame = [self separatorViewFrame];
}

- (CGRect)headingLabelFrame {
    CGFloat marginX = FORMTextFieldCellMarginX + FORMTextFormFieldCellLabelMarginX;
    CGFloat marginTop = FORMTextFormFieldCellLabelMarginTop;

    CGFloat width = CGRectGetWidth(self.frame) - (marginX * 2);
    CGFloat height = FORMTextFormFieldCellLabelHeight;
    CGRect frame = CGRectMake(marginX, marginTop, width, height);

    return frame;
}

- (CGRect)separatorViewFrame {
    CGRect frame = self.frame;
    frame.origin.x = 0.0f;
    frame.origin.y = CGRectGetHeight(frame) - 1.0f;
    frame.size.height = 1.0f;

    return frame;
}

#pragma mark - Styling

- (void)setHeadingLabelFont:(UIFont *)font {
    NSString *styleFont = [self.styles valueForKey:FORMHeadingLabelFontKey];
    NSString *styleFontSize = [self.styles valueForKey:FORMHeadingLabelFontSizeKey];
    if ([styleFont length] > 0) {
        if ([styleFontSize length] > 0) {
            font = [UIFont fontWithName:styleFont size:[styleFontSize floatValue]];
        } else {
            font = [UIFont fontWithName:styleFont size:font.pointSize];
        }
    }
    
    self.headingLabel.font = font;
}

- (void)setHeadingLabelTextColor:(UIColor *)color {
    NSString *style = [self.styles valueForKey:FORMHeadingLabelTextColorKey];
    if ([style length] > 0) {
        color = [[UIColor alloc] initWithHex:style];
    }
    
    self.headingLabel.textColor = color;
}

@end
