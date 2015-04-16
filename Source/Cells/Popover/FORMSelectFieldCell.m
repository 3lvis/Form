#import "FORMSelectFieldCell.h"

#import "FORMFieldValue.h"

static const CGSize FORMSelectPopoverSize = { .width = 320.0f, .height = 308.0f };

@interface FORMSelectFieldCell () <FORMTextFieldDelegate, FORMFieldValuesTableViewControllerDelegate>

@end

@implementation FORMSelectFieldCell

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame contentViewController:self.fieldValuesController
                 andContentSize:FORMSelectPopoverSize];
    if (!self) return nil;

    self.iconImageView.image = [UIImage imageNamed:@"ic_mini_arrow_down"];

    return self;
}

#pragma mark - Getters

- (FORMFieldValuesTableViewController *)fieldValuesController {
    if (_fieldValuesController) return _fieldValuesController;

    _fieldValuesController = [FORMFieldValuesTableViewController new];
    _fieldValuesController.delegate = self;

    return _fieldValuesController;
}

#pragma mark - FORMBaseFormFieldCell

- (void)updateWithField:(FORMField *)field {
    [super updateWithField:field];

    if (field.value) {
        if ([field.value isKindOfClass:[FORMFieldValue class]]) {
            FORMFieldValue *fieldValue = (FORMFieldValue *)field.value;
            self.fieldValueLabel.text = fieldValue.title;
        } else {

            for (FORMFieldValue *fieldValue in field.values) {
                if ([fieldValue identifierIsEqualTo:field.value]) {
                    field.value = fieldValue;
                    self.fieldValueLabel.text = fieldValue.title;
                    break;
                }
            }
        }
    } else {
        self.fieldValueLabel.text = nil;
    }
}

#pragma mark - FORMPopoverFormFieldCell

- (void)updateContentViewController:(UIViewController *)contentViewController withField:(FORMField *)field {
    self.fieldValuesController.field = self.field;
}

#pragma mark - FORMFieldValuesTableViewControllerDelegate

- (void)fieldValuesTableViewController:(FORMFieldValuesTableViewController *)fieldValuesTableViewController
                      didSelectedValue:(FORMFieldValue *)selectedValue {
    self.field.value = selectedValue;

    [self updateWithField:self.field];

    [self validate];

    [self.popoverController dismissPopoverAnimated:YES];

    if ([self.delegate respondsToSelector:@selector(fieldCell:updatedWithField:)]) {
        [self.delegate fieldCell:self updatedWithField:self.field];
    }
}

@end
