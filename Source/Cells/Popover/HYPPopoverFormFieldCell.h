#import "HYPBaseFormFieldCell.h"
#import "HYPFieldValueLabel.h"
#import "HYPFieldValuesTableViewController.h"

@interface HYPPopoverFormFieldCell : HYPBaseFormFieldCell

@property (nonatomic, strong) HYPFieldValueLabel *fieldValueLabel;
@property (nonatomic, strong) UIPopoverController *popoverController;
@property (nonatomic, strong) UIImageView *iconImageView;

- (instancetype)initWithFrame:(CGRect)frame contentViewController:(UIViewController *)controller
               andContentSize:(CGSize)contentSize;

- (void)updateContentViewController:(UIViewController *)contentViewController withField:(HYPFormField *)field;

@end
