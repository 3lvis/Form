#import "HYPSelectFormFieldCell.h"

static NSString * const HYPDateFormFieldCellIdentifier = @"HYPDateFormFieldCellIdentifier";

@interface HYPDateFormFieldCell : HYPSelectFormFieldCell

@property (nonatomic, copy) NSDate *date;
@property (nonatomic, copy) NSDate *minimumDate;
@property (nonatomic, copy) NSDate *maximumDate;

@end
