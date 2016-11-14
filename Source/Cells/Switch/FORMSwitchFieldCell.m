#import "FORMSwitchFieldCell.h"
@import Hex;
#import "FORMFieldValue.h"

static NSString * const FORMSwitchTintColorKey = @"tint_color";
static NSString * const FORMSwitchBackgroundColorKey = @"background_color";

static const CGFloat FORMSwitchFieldCellMarginTop = 36.0f;
static const CGFloat FORMSwitchFieldCellMarginBottom = 4.0f;

@interface FORMSwitchFieldCell ()

@property (nonatomic) UISwitch *switchControl;

@end

@implementation FORMSwitchFieldCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    self.switchControl = [[UISwitch alloc] initWithFrame:frame];
    [self.switchControl addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:self.switchControl];
    
    return self;
}

#pragma mark - FORMBaseFormFieldCell

- (void)updateFieldWithDisabled:(BOOL)disabled {
    self.switchControl.alpha = disabled ? 0.5f : 1.0f;
    self.switchControl.enabled = disabled ? NO : YES;
}

- (void)updateWithField:(FORMField *)field {
    [super updateWithField:field];
    
    self.switchControl.enabled = !field.disabled;
    self.disabled = field.disabled;
    self.switchControl.on = [field.value boolValue];
    
    if ([field.accessibilityLabel length] > 0) {
        self.switchControl.accessibilityLabel = field.accessibilityLabel;
    } else {
        self.switchControl.accessibilityLabel = self.headingLabel.text;
    }
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.switchControl.frame = [self switchFrame];
}

- (CGRect)switchFrame {
    CGFloat marginX = FORMTextFieldCellMarginX;
    CGFloat marginTop = FORMSwitchFieldCellMarginTop;
    CGFloat marginBotton = FORMSwitchFieldCellMarginBottom;
    
    CGFloat width  = CGRectGetWidth(self.frame) - (marginX * 2);
    CGFloat height = CGRectGetHeight(self.frame) - marginTop - marginBotton;
    CGRect  frame  = CGRectMake(marginX, marginTop, width, height);
    
    return frame;
}

#pragma mark - Actions

- (void)switchAction:(id)sender {
    self.field.value = [sender isOn] ? @YES : @NO;
    
    if ([self.delegate respondsToSelector:@selector(fieldCell:updatedWithField:)]) {
        [self.delegate fieldCell:self updatedWithField:self.field];
    }
}

#pragma mark - Styling

- (void)setTintColor:(UIColor *)tintColor {
    NSString *style = [self.field.styles valueForKey:FORMSwitchTintColorKey];
    if ([style length] > 0) {
        tintColor = [[UIColor alloc] initWithHex:style];
    }
    
    self.switchControl.onTintColor = tintColor;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    NSString *style = [self.field.styles valueForKey:FORMSwitchBackgroundColorKey];
    if ([style length] > 0) {
        backgroundColor = [[UIColor alloc] initWithHex:style];
    }
    
    self.switchControl.backgroundColor = backgroundColor;
}

@end
