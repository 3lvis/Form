#import "HYPPopoverFormFieldCell.h"
#import "HYPFieldValuesTableViewController.h"

static NSString * const HYPDropdownFormFieldCellIdentifier = @"HYPDropdownFormFieldCellIdentifier";

@interface HYPDropdownFormFieldCell : HYPPopoverFormFieldCell

@property (nonatomic, strong) HYPFieldValuesTableViewController *fieldValuesController;

@end
