#import "FORMSelectFieldCell.h"

static NSString * const FORMDateFormFieldCellIdentifier = @"FORMDateFormFieldCellIdentifier";

@interface FORMDateFieldCell : FORMSelectFieldCell

@property (nonatomic) NSDate *date;
@property (nonatomic) NSDate *minimumDate;
@property (nonatomic) NSDate *maximumDate;

@end
