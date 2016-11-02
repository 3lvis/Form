#import "FORMSelectFieldCell.h"

#import "FORMFieldValue.h"

static const CGSize FORMSelectPopoverSize = { .width = 320.0f, .height = 308.0f };
static const NSInteger FORMSelectMaxItemCount = 6;

@interface FORMSelectFieldCell () <FORMTextFieldDelegate, FORMFieldValuesTableViewControllerDelegate>

@end

@implementation FORMSelectFieldCell

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame contentViewController:self.fieldValuesController
                 andContentSize:FORMSelectPopoverSize];
    if (!self) return nil;

    NSString *bundlePath = [[[NSBundle bundleForClass:self.class] resourcePath] stringByAppendingPathComponent:@"Form.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath: bundlePath];

    UITraitCollection *trait = [UITraitCollection traitCollectionWithDisplayScale:2.0];
    self.iconImageView.image = [UIImage imageNamed:@"arrow_down"
                                          inBundle:bundle
                     compatibleWithTraitCollection:trait];
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
            self.fieldValueLabel.text = nil;

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

    if ([field.accessibilityLabel length] > 0) {
        self.fieldValueLabel.accessibilityLabel = field.accessibilityLabel;
    } else {
        self.fieldValueLabel.accessibilityLabel = field.title;
    }
    self.fieldValueLabel.accessibilityValue = self.fieldValueLabel.text;
}

#pragma mark - FORMPopoverFormFieldCell

- (void)updateContentViewController:(UIViewController *)contentViewController
                          withField:(FORMField *)field {
    self.fieldValuesController.field = self.field;

    if (self.field.values.count <= FORMSelectMaxItemCount) {
        CGSize currentSize = FORMSelectPopoverSize;

        CGFloat labelHeight = floorf(self.fieldValuesController.headerView.labelHeight);
        CGSize customSize = CGSizeMake(currentSize.width, (FORMFieldValuesCellHeight * self.field.values.count) + labelHeight + FORMInfoLabelY);

        self.fieldValuesController.preferredContentSize = customSize;
    }
}

#pragma mark - FORMFieldValuesTableViewControllerDelegate

- (void)fieldValuesTableViewController:(FORMFieldValuesTableViewController *)fieldValuesTableViewController
                      didSelectedValue:(FORMFieldValue *)selectedValue {
    self.field.value = selectedValue;

    [self updateWithField:self.field];

    [self validate];

    [fieldValuesTableViewController dismissViewControllerAnimated:YES completion:nil];

    if ([self.delegate respondsToSelector:@selector(fieldCell:updatedWithField:)]) {
        [self.delegate fieldCell:self updatedWithField:self.field];
    }
}

@end
