@import Foundation;
@import UIKit;
@class FORMFieldValue;

static NSString * const FORMFieldValueCellIdentifer = @"FORMFieldValueCellIdentifer";

@interface FORMFieldValueCell : UITableViewCell

@property (nonatomic, weak) FORMFieldValue *fieldValue;

@end
