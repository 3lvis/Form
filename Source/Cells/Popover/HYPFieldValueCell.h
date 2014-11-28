@import Foundation;
@import UIKit;
@class HYPFieldValue;

static NSString * const HYPFieldValueCellIdentifer = @"HYPFieldValueCellIdentifer";

@interface HYPFieldValueCell : UITableViewCell

@property (nonatomic, weak) HYPFieldValue *fieldValue;

@end
