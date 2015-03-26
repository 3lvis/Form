@import UIKit;

#import "FORMBaseFieldCell.h"

static NSString * const FORMResignFirstResponderNotification = @"FORMResignFirstResponderNotification";
static NSString * const FORMDismissTooltipNotification = @"FORMDismissTooltipNotification";
static NSString * const FORMTextFieldCellIdentifier = @"FORMTextFieldCellIdentifier";

@interface FORMTextFieldCell : FORMBaseFieldCell

- (void)setTooltipLabelFont:(UIFont *)tooltipLabelFont UI_APPEARANCE_SELECTOR;
- (void)setTooltipLabelTextColor:(UIColor *)tooltipLabelTextColor UI_APPEARANCE_SELECTOR;
- (void)setTooltipBackgroundColor:(UIColor *)tooltipBackgroundColor UI_APPEARANCE_SELECTOR;

@end
