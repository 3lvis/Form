@import UIKit;

#import "HYPFieldValuesTableViewHeader.h"

@class HYPFieldValue;
@class HYPFormField;

@protocol HYPFieldValuesTableViewControllerDelegate;

@interface HYPFieldValuesTableViewController : UITableViewController

@property (nonatomic, weak) HYPFormField *field;
@property (nonatomic, strong) HYPFieldValuesTableViewHeader *headerView;
@property (nonatomic) CGFloat customHeight;

@property (nonatomic, weak) id <HYPFieldValuesTableViewControllerDelegate> delegate;

@end


@protocol HYPFieldValuesTableViewControllerDelegate <NSObject>

- (void)fieldValuesTableViewController:(HYPFieldValuesTableViewController *)fieldValuesTableViewController
                      didSelectedValue:(HYPFieldValue *)selectedValue;

@end
