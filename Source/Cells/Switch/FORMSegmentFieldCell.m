#import "FORMSegmentFieldCell.h"
#import "UIColor+Hex.h"
#import "FORMFieldValue.h"

static NSString * const FORMSegmentLabelFontKey = @"font";
static NSString * const FORMSegmentLabelFontSizeKey = @"font_size";
static NSString * const FORMSegmentTintColorKey = @"tint_color";
static NSString * const FORMSegmentBackgroundColorKey = @"background_color";

@interface FORMSegmentFieldCell ()
    
@property (nonatomic) UISegmentedControl *segment;
@property (nonatomic) NSArray *values;
    
@end

@implementation FORMSegmentFieldCell
    
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    self.segment = [[UISegmentedControl alloc] initWithFrame:frame];
    [self.segment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:self.segment];
    
    return self;
}
    
#pragma mark - FORMBaseFormFieldCell
    
- (void)updateFieldWithDisabled:(BOOL)disabled {
    self.segment.alpha = disabled ? 0.5f : 1.0f;
    self.segment.enabled = disabled ? NO : YES;
}
    
- (void)updateWithField:(FORMField *)field {
    [super updateWithField:field];
    
    self.segment.enabled = !field.disabled;
    self.disabled = field.disabled;
    
    NSInteger selectedIndex = [self.segment selectedSegmentIndex];
    
    [self.segment removeAllSegments];

    [field.values enumerateObjectsUsingBlock:^(FORMFieldValue *value, NSUInteger index, BOOL *stop) {
        [self.segment insertSegmentWithTitle:value.title atIndex:index animated:NO];

        if (selectedIndex || selectedIndex == 0) {
            [self.segment setSelectedSegmentIndex:selectedIndex];
        } else if (value.defaultValue) {
            [self.segment setSelectedSegmentIndex:index];
        }
    }];
    
    if ([field.accessibilityLabel length] > 0) {
        self.segment.accessibilityLabel = field.accessibilityLabel;
    } else {
        self.segment.accessibilityLabel = self.headingLabel.text;
    }
}
    
#pragma mark - Layout
    
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.segment.frame = [self segmentFrame];
}
    
- (CGRect)segmentFrame {
    CGFloat marginX = FORMTextFieldCellMarginX;
    CGFloat marginTop = FORMFieldCellMarginTop;
    CGFloat marginBotton = FORMFieldCellMarginBottom;
    
    CGFloat width  = CGRectGetWidth(self.frame) - (marginX * 2);
    CGFloat height = CGRectGetHeight(self.frame) - marginTop - marginBotton;
    CGRect  frame  = CGRectMake(marginX, marginTop, width, height);
    
    return frame;
}
    
#pragma mark - Actions
    
- (void)segmentAction:(id)sender {
    FORMFieldValue *value = [self.field.values objectAtIndex:[sender selectedSegmentIndex]];
    self.field.value = value;
    
    if ([self.delegate respondsToSelector:@selector(fieldCell:updatedWithField:)]) {
        [self.delegate fieldCell:self updatedWithField:self.field];
    }
}
    
#pragma mark - Styling

- (void)setLabelFont:(UIFont *)labelFont {
    NSString *styleFont = [self.field.styles valueForKey:FORMSegmentLabelFontKey];
    NSString *styleFontSize = [self.field.styles valueForKey:FORMSegmentLabelFontSizeKey];
    if ([styleFont length] > 0) {
        if ([styleFontSize length] > 0) {
            labelFont = [UIFont fontWithName:styleFont size:[styleFontSize floatValue]];
        } else {
            labelFont = [UIFont fontWithName:styleFont size:labelFont.pointSize];
        }
    }

    NSDictionary *attributes = [NSDictionary dictionaryWithObject:labelFont forKey:NSFontAttributeName];
    [self.segment setTitleTextAttributes:attributes forState:UIControlStateNormal];
}

- (void)setTintColor:(UIColor *)tintColor {
    NSString *style = [self.field.styles valueForKey:FORMSegmentTintColorKey];
    if ([style length] > 0) {
        tintColor = [[UIColor alloc] initWithHex:style];
    }
    
    self.segment.tintColor = tintColor;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    NSString *style = [self.field.styles valueForKey:FORMSegmentBackgroundColorKey];
    if ([style length] > 0) {
        backgroundColor = [[UIColor alloc] initWithHex:style];
    }
    
    self.segment.backgroundColor = backgroundColor;
}

@end
