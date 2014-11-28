@import UIKit;

#import "HYPFormField.h"

static const CGFloat HYPFieldValuesHeaderWidth = 320.0f;
static const CGFloat HYPFieldValuesHeaderHeight = 66.0f;

static NSString * const HYPFieldValuesTableViewHeaderIdentifier = @"HYPFieldValuesTableViewHeaderIdentifier";

@interface HYPFieldValuesTableViewHeader : UITableViewHeaderFooterView

@property (nonatomic, weak) HYPFormField *field;

@end
