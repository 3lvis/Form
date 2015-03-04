#import "FORMSelectFieldCell.h"

static NSString * const FORMDateFormFieldCellIdentifier = @"FORMDateFormFieldCellIdentifier";

@interface FORMDateFieldCell : FORMSelectFieldCell

@property (nonatomic, copy) NSDate *date;
@property (nonatomic, copy) NSDate *minimumDate;
@property (nonatomic, copy) NSDate *maximumDate;

@end
