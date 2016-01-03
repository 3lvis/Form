@import UIKit;

#import "FORMBaseFieldCell.h"
@import FormTextField;

static NSString * const FORMResignFirstResponderNotification = @"FORMResignFirstResponderNotification";
static NSString * const FORMDismissTooltipNotification = @"FORMDismissTooltipNotification";
static NSString * const FORMTextFieldCellIdentifier = @"FORMTextFieldCellIdentifier";
static NSString * const FORMCountFieldCellIdentifier = @"FORMCountFieldCellIdentifier";

@interface FORMTextFieldCell : FORMBaseFieldCell

@property (nonatomic) FormTextField *textField;

- (void)setTooltipLabelFont:(UIFont *)tooltipLabelFont UI_APPEARANCE_SELECTOR;
- (void)setTooltipLabelTextColor:(UIColor *)tooltipLabelTextColor UI_APPEARANCE_SELECTOR;
- (void)setTooltipBackgroundColor:(UIColor *)tooltipBackgroundColor UI_APPEARANCE_SELECTOR;

// Required methods for Swift extension
- (NSString *)rawTextForField:(FORMField *)field;
- (void)showTooltip;
@property (nonatomic) BOOL showTooltips;

@end
