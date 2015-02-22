#import "FORMPopoverFieldCell.h"
#import "FORMFieldValuesTableViewController.h"

static NSString * const HYPSelectFormFieldCellIdentifier = @"HYPSelectFormFieldCellIdentifier";

@interface FORMSelectFieldCell : FORMPopoverFieldCell

@property (nonatomic, strong) FORMFieldValuesTableViewController *fieldValuesController;

@end
