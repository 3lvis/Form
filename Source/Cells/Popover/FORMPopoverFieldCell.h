#import "FORMBaseFieldCell.h"
#import "FORMFieldValueLabel.h"
#import "FORMFieldValuesTableViewController.h"

@interface FORMPopoverFieldCell : FORMBaseFieldCell

@property (nonatomic, strong) FORMFieldValueLabel *fieldValueLabel;
@property (nonatomic, strong) UIPopoverController *popoverController;
@property (nonatomic, strong) UIImageView *iconImageView;

- (instancetype)initWithFrame:(CGRect)frame contentViewController:(UIViewController *)controller
               andContentSize:(CGSize)contentSize;

- (void)updateContentViewController:(UIViewController *)contentViewController withField:(FORMField *)field;

@end
