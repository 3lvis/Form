#import "HYPBaseFormFieldCell.h"

@interface HYPPopoverFormFieldCell : HYPBaseFormFieldCell

@property (nonatomic, strong) HYPTextFormField *textField;
@property (nonatomic, strong) UIPopoverController *popoverController;
@property (nonatomic, strong) UIImageView *iconImageView;

- (instancetype)initWithFrame:(CGRect)frame contentViewController:(UIViewController *)controller
               andContentSize:(CGSize)contentSize;

- (void)updateContentViewController:(UIViewController *)contentViewController withField:(HYPFormField *)field;

@end
