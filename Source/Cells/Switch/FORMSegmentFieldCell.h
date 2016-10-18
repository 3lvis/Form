@import UIKit;

#import "FORMBaseFieldCell.h"

static NSString * const FORMSegmentFieldCellIdentifier = @"FORMSegmentFieldCellIdentifier";

@interface FORMSegmentFieldCell : FORMBaseFieldCell
    
- (void)setLabelFont:(UIFont *)labelFont UI_APPEARANCE_SELECTOR;
- (void)setTintColor:(UIColor *)tintColor UI_APPEARANCE_SELECTOR;
- (void)setBackgroundColor:(UIColor *)backgroundColor UI_APPEARANCE_SELECTOR;
    
@end
