#import "FORMGroupHeaderView.h"
#import "UIColor+Hex.h"

static NSString * const FORMHeaderLabelFontKey = @"font";
static NSString * const FORMHeaderLabelFontSizeKey = @"font_size";
static NSString * const FORMHeaderLabelTextColorKey = @"text_color";
static NSString * const FORMHeaderBackgroundColorKey = @"background_color";

@interface FORMGroupHeaderView ()

@property (nonatomic) UIView *contentView;

@end

@implementation FORMGroupHeaderView

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;

    self.backgroundColor = [UIColor whiteColor];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;

    [self addSubview:self.headerLabel];

    self.layer.masksToBounds = NO;
    self.layer.cornerRadius = 5;
    self.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    self.layer.shadowRadius = 1;
    self.layer.shadowOpacity = 0.2;

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(headerTappedAction)];
    [self addGestureRecognizer:tapGestureRecognizer];

    return self;
}

#pragma mark - Getters

- (CGRect)headerLabelFrame {
    CGFloat width = CGRectGetWidth(self.bounds) - (FORMTitleMargin * 2);
    
    return CGRectMake(FORMTitleMargin, 0.0f, width, FORMHeaderHeight);
}

- (UILabel *)headerLabel {
    if (_headerLabel) return _headerLabel;

    _headerLabel = [[UILabel alloc] initWithFrame:[self headerLabelFrame]];
    _headerLabel.backgroundColor = [UIColor clearColor];
    _headerLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;

    return _headerLabel;
}

#pragma mark - Actions

- (void)headerTappedAction {
    if ([self.delegate respondsToSelector:@selector(groupHeaderViewWasPressed:)]) {
        if (self.collapsible) {
            [self.delegate groupHeaderViewWasPressed:self];
        }
    }
}

#pragma mark - Styling

- (void)setHeaderLabelFont:(UIFont *)headerLabelFont {
    NSString *styleFont = [self.styles valueForKey:FORMHeaderLabelFontKey];
    NSString *styleFontSize = [self.styles valueForKey:FORMHeaderLabelFontSizeKey];
    if ([styleFont length] > 0) {
        if ([styleFontSize length] > 0) {
            headerLabelFont = [UIFont fontWithName:styleFont size:[styleFontSize floatValue]];
        } else {
            headerLabelFont = [UIFont fontWithName:styleFont size:headerLabelFont.pointSize];
        }
    }
    
    self.headerLabel.font = headerLabelFont;
}

- (void)setHeaderLabelTextColor:(UIColor *)headerLabelTextColor {
    NSString *style = [self.styles valueForKey:FORMHeaderLabelTextColorKey];
    if ([style length] > 0) {
        headerLabelTextColor = [UIColor form_colorFromHex:style];
    }
    
    self.headerLabel.textColor = headerLabelTextColor;
}

- (void)setHeaderBackgroundColor:(UIColor *)backgroundColor {
    NSString *style = [self.styles valueForKey:FORMHeaderBackgroundColorKey];
    if ([style length] > 0) {
        backgroundColor = [UIColor form_colorFromHex:style];
    }
    
    self.backgroundColor = backgroundColor;
}

@end
