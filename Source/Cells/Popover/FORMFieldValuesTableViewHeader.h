@import UIKit;

#import "FORMField.h"

static const CGFloat FORMFieldValuesHeaderWidth = 320.0f;
static const CGFloat FORMFieldValuesHeaderHeight = 66.0f;
static const CGFloat FORMLabelHeight = 25.0f;
static const CGFloat FORMInfoLabelY = 8.0f;

static NSString * const FORMFieldValuesTableViewHeaderIdentifier = @"FORMFieldValuesTableViewHeaderIdentifier";

@interface FORMFieldValuesTableViewHeader : UITableViewHeaderFooterView

@property (nonatomic, weak) FORMField *field;

@property (nonatomic, readonly) CGFloat labelHeight;

- (void)setInfoLabelFont:(UIFont *)infoLabelFont UI_APPEARANCE_SELECTOR;
- (void)setInfoLabelTextColor:(UIColor *)infoLabelTextColor UI_APPEARANCE_SELECTOR;

@end
