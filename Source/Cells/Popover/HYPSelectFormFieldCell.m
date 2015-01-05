#import "HYPSelectFormFieldCell.h"

#import "HYPFieldValue.h"

static const CGSize HYPSelectPopoverSize = { .width = 320.0f, .height = 308.0f };

@interface HYPSelectFormFieldCell () <HYPTextFieldDelegate, HYPFieldValuesTableViewControllerDelegate>

@end

@implementation HYPSelectFormFieldCell

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame contentViewController:self.fieldValuesController
                 andContentSize:HYPSelectPopoverSize];
    if (!self) return nil;

    self.iconImageView.image = [UIImage imageNamed:@"ic_mini_arrow_down"];
    self.fieldValuesController.customHeight = 44.0f;

    return self;
}

#pragma mark - Getters

- (HYPFieldValuesTableViewController *)fieldValuesController
{
    if (_fieldValuesController) return _fieldValuesController;

    _fieldValuesController = [[HYPFieldValuesTableViewController alloc] init];
    _fieldValuesController.delegate = self;

    return _fieldValuesController;
}

#pragma mark - Private headers

- (void)updateWithField:(HYPFormField *)field
{
    [super updateWithField:field];

    if (field.fieldValue) {
        if ([field.fieldValue isKindOfClass:[HYPFieldValue class]]) {
            HYPFieldValue *fieldValue = (HYPFieldValue *)field.fieldValue;
            self.fieldValueLabel.text = fieldValue.title;
        } else {

            for (HYPFieldValue *fieldValue in field.values) {
                if ([fieldValue identifierIsEqualTo:field.fieldValue]) {
                    field.fieldValue = fieldValue;
                    self.fieldValueLabel.text = fieldValue.title;
                    break;
                }
            }
        }
    } else {
        HYPFieldValue *defaultFieldValue;

        for (HYPFieldValue *fieldValue in field.values) {
            if (fieldValue.defaultValue) {
                defaultFieldValue = fieldValue;
                break;
            }
        }

        self.fieldValueLabel.text = (defaultFieldValue) ? defaultFieldValue.title : nil;
    }
}

- (void)updateContentViewController:(UIViewController *)contentViewController withField:(HYPFormField *)field
{
    self.fieldValuesController.field = self.field;
}

#pragma mark - HYPFieldValuesTableViewControllerDelegate

- (void)fieldValuesTableViewController:(HYPFieldValuesTableViewController *)fieldValuesTableViewController
                      didSelectedValue:(HYPFieldValue *)selectedValue
{
    self.field.fieldValue = selectedValue;

    [self updateWithField:self.field];

    [self validate];

    [self.popoverController dismissPopoverAnimated:YES];

    if ([self.delegate respondsToSelector:@selector(fieldCell:updatedWithField:)]) {
        [self.delegate fieldCell:self updatedWithField:self.field];
    }
}

@end
