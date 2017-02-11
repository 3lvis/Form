#import "FORMButtonFieldCell.h"
#import "UIColor+FORMImage.h"
#import "UIColor+Hex.h"

static NSString * const FORMButtonTitleLabelFontKey = @"font";
static NSString * const FORMButtonTitleLabelFontSizeKey = @"font_size";
static NSString * const FORMButtonBorderWidthKey = @"border_width";
static NSString * const FORMButtonCornerRadiusKey = @"corner_radius";
static NSString * const FORMButtonHighlightedTitleColorKey = @"highlighted_title_color";
static NSString * const FORMButtonBorderColorKey = @"border_color";
static NSString * const FORMButtonHighlightedBackgroundColorKey = @"highlighted_background_color";
static NSString * const FORMButtonTitleColorKey = @"title_color";
static NSString * const FORMButtonBackgroundColorKey = @"background_color";

@interface FORMButtonFieldCell ()

@property (nonatomic) UIButton *button;

@end

@implementation FORMButtonFieldCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;

    [self.contentView addSubview:self.button];
    self.headingLabel.hidden = YES;

    return self;
}

#pragma mark - Getters

- (UIButton *)button {
    if (_button) return _button;

    _button = [UIButton buttonWithType:UIButtonTypeCustom];

    [_button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];

    return _button;
}

#pragma mark - FORMBaseFormFieldCell

- (void)updateFieldWithDisabled:(BOOL)disabled {
    self.button.alpha = disabled ? 0.5f : 1.0f;
    self.button.enabled = disabled ? NO : YES;
}

- (void)updateWithField:(FORMField *)field {
    [super updateWithField:field];

    self.button.enabled = !field.disabled;
    self.disabled = field.disabled;
    self.headingLabel.hidden = YES;
    
    if ([field.accessibilityLabel length] > 0) {
        self.button.accessibilityLabel = field.accessibilityLabel;
    } else {
        self.button.accessibilityLabel = self.headingLabel.text;
    }

    [self.button setTitle:field.title forState:UIControlStateNormal];
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];

    self.button.frame = [self buttonFrame];
}

- (CGRect)buttonFrame {
    CGFloat marginX = FORMTextFieldCellMarginX;
    CGFloat marginTop = FORMFieldCellMarginTop;
    CGFloat marginBotton = FORMFieldCellMarginBottom;

    CGFloat width  = CGRectGetWidth(self.frame) - (marginX * 2);
    CGFloat height = CGRectGetHeight(self.frame) - marginTop - marginBotton;
    CGRect  frame  = CGRectMake(marginX, marginTop, width, height);

    return frame;
}

#pragma mark - Actions

- (void)buttonAction {
    if ([self.delegate respondsToSelector:@selector(fieldCell:updatedWithField:)]) {
        [self.delegate fieldCell:self updatedWithField:self.field];
    }
}

#pragma mark - Styling

- (void)setTitleLabelFont:(UIFont *)titleLabelFont {
    NSString *styleFont = [self.field.styles valueForKey:FORMButtonTitleLabelFontKey];
    NSString *styleFontSize = [self.field.styles valueForKey:FORMButtonTitleLabelFontSizeKey];
    if ([styleFont length] > 0) {
        if ([styleFontSize length] > 0) {
            titleLabelFont = [UIFont fontWithName:styleFont size:[styleFontSize floatValue]];
        } else {
            titleLabelFont = [UIFont fontWithName:styleFont size:titleLabelFont.pointSize];
        }
    }
    self.button.titleLabel.font = titleLabelFont;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    NSString *style = [self.field.styles valueForKey:FORMButtonBorderWidthKey];
    if ([style length] > 0) {
        borderWidth = [style floatValue];
    }
    self.button.layer.borderWidth = borderWidth;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    NSString *style = [self.field.styles valueForKey:FORMButtonCornerRadiusKey];
    if ([style length] > 0) {
        cornerRadius = [style floatValue];
    }
    self.button.layer.cornerRadius = cornerRadius;
}

- (void)setHighlightedTitleColor:(UIColor *)highlightedTitleColor {
    NSString *style = [self.field.styles valueForKey:FORMButtonHighlightedTitleColorKey];
    if ([style length] > 0) {
        highlightedTitleColor = [[UIColor alloc] initWithHex:style];
    }

    [self.button setTitleColor:highlightedTitleColor forState:UIControlStateHighlighted];
}

- (void)setBorderColor:(UIColor *)borderColor {
    NSString *style = [self.field.styles valueForKey:FORMButtonBorderColorKey];
    if ([style length] > 0) {
        borderColor = [[UIColor alloc] initWithHex:style];
    }
    self.button.layer.borderColor = borderColor.CGColor;
}

- (void)setHighlightedBackgroundColor:(UIColor *)highlightedBackgroundColor {
    NSString *style = [self.field.styles valueForKey:FORMButtonHighlightedBackgroundColorKey];
    if ([style length] > 0) {
        highlightedBackgroundColor = [[UIColor alloc] initWithHex:style];
    }

    [self.button setBackgroundImage:[highlightedBackgroundColor form_image] forState:UIControlStateHighlighted];
}

- (void)setTitleColor:(UIColor *)titleColor {
    NSString *style = [self.field.styles valueForKey:FORMButtonTitleColorKey];
    if ([style length] > 0) {
        titleColor = [[UIColor alloc] initWithHex:style];
    }

    [self.button setTitleColor:titleColor forState:UIControlStateNormal];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    NSString *style = [self.field.styles valueForKey:FORMButtonBackgroundColorKey];
    if ([style length] > 0) {
        backgroundColor = [[UIColor alloc] initWithHex:style];
    }
    self.button.backgroundColor = backgroundColor;
}

@end
