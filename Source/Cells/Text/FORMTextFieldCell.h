@import UIKit;

#import "FORMBaseFieldCell.h"

static NSString * const FORMResignFirstResponderNotification = @"FORMResignFirstResponderNotification";
static NSString * const FORMHideTooltips = @"FORMHideTooltips";
static NSString * const FORMDismissTooltipNotification = @"FORMDismissTooltipNotification";
static NSString * const FORMTextFieldCellIdentifier = @"FORMTextFieldCellIdentifier";

@interface FORMTextFieldCell : FORMBaseFieldCell

- (void)setSubtitleLabelFont:(UIFont *)subtitleLabelFont UI_APPEARANCE_SELECTOR;
- (void)setSubtitleLabelTextColor:(UIColor *)subtitleLabelTextColor UI_APPEARANCE_SELECTOR;

@end
