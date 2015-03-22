@import Foundation;
@import UIKit;
@class FORMFieldValue;

static NSString * const FORMFieldValueCellIdentifer = @"FORMFieldValueCellIdentifer";

@interface FORMFieldValueCell : UITableViewCell

@property (nonatomic, weak) FORMFieldValue *fieldValue;

- (void)setTextLabelFont:(UIFont *)font UI_APPEARANCE_SELECTOR;
- (void)setTextLabelColor:(UIColor *)textColor UI_APPEARANCE_SELECTOR;
- (void)setHighlightedTextColor:(UIColor *)highlightedTextColor UI_APPEARANCE_SELECTOR;
- (void)setDetailTextLabelFont:(UIFont *)font UI_APPEARANCE_SELECTOR;
- (void)setDetailTextLabelColor:(UIColor *)textColor UI_APPEARANCE_SELECTOR;
- (void)setDetailTextLabelHighlightedTextColor:(UIColor *)highlightedTextColor UI_APPEARANCE_SELECTOR;
- (void)setSelectedBackgroundViewColor:(UIColor *)backgroundColor UI_APPEARANCE_SELECTOR;
- (void)setSelectedBackgroundFontColor:(UIColor *)fontColor UI_APPEARANCE_SELECTOR;

@end
