@import UIKit;

#import "FORMField.h"

static const CGFloat FORMFieldValuesHeaderWidth = 320.0f;
static const CGFloat FORMFieldValuesHeaderHeight = 66.0f;

static NSString * const FORMFieldValuesTableViewHeaderIdentifier = @"FORMFieldValuesTableViewHeaderIdentifier";

@interface FORMFieldValuesTableViewHeader : UITableViewHeaderFooterView

@property (nonatomic, weak) FORMField *field;

@end
