#import "FORMBaseFieldCell.h"
#import "FORMFieldValueLabel.h"
#import "FORMFieldValuesTableViewController.h"

@interface FORMPopoverFieldCell : FORMBaseFieldCell

@property (nonatomic) FORMFieldValueLabel *fieldValueLabel;
@property (nonatomic) UIPopoverController *popoverController;
@property (nonatomic) UIImageView *iconImageView;

- (instancetype)initWithFrame:(CGRect)frame contentViewController:(UIViewController *)controller
               andContentSize:(CGSize)contentSize NS_DESIGNATED_INITIALIZER;

- (void)updateContentViewController:(UIViewController *)contentViewController withField:(FORMField *)field;

@end
