#import "HYPPopoverFormFieldCell.h"
#import "HYPFieldValuesTableViewController.h"

static NSString * const HYPSelectFormFieldCellIdentifier = @"HYPSelectFormFieldCellIdentifier";

@interface HYPSelectFormFieldCell : HYPPopoverFormFieldCell

@property (nonatomic, strong) HYPFieldValuesTableViewController *fieldValuesController;

@end
