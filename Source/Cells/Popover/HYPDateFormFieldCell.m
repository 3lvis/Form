#import "HYPDateFormFieldCell.h"
#import "HYPFieldValue.h"

static const CGSize HYPDatePopoverSize = { 320.0f, 328.0f };

@interface HYPDateFormFieldCell () <HYPTextFieldDelegate,
UIPopoverControllerDelegate, HYPFieldValuesTableViewControllerDelegate>

@property (nonatomic, strong) UIPopoverController *popoverController;
@property (nonatomic, strong) UIDatePicker *datePicker;

@end

@implementation HYPDateFormFieldCell

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame contentViewController:self.fieldValuesController
                 andContentSize:HYPDatePopoverSize];
    if (!self) return nil;

    [self.iconButton setImage:[UIImage imageNamed:@"ic_calendar"] forState:UIControlStateNormal];

    self.fieldValuesController.delegate = self;
    self.fieldValuesController.customHeight = 240.0f;
    self.fieldValuesController.tableView.scrollEnabled = NO;
    [self.fieldValuesController.headerView addSubview:self.datePicker];

    return self;
}

#pragma mark - Getters

- (UIDatePicker *)datePicker
{
    if (_datePicker) return _datePicker;

    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0f, 25.0f, HYPDatePopoverSize.width,
                                                                 HYPDatePopoverSize.height)];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    _datePicker.backgroundColor = [UIColor clearColor];

    [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];

    return _datePicker;
}

#pragma mark - Setters

- (void)setDate:(NSDate *)date
{
    _date = date;

    if (_date) self.datePicker.date = _date;
}

- (void)setMinimumDate:(NSDate *)minimumDate
{
    _minimumDate = minimumDate;

    self.datePicker.minimumDate = _minimumDate;
}

- (void)setMaximumDate:(NSDate *)maximumDate
{
    _maximumDate = maximumDate;

    self.datePicker.maximumDate = _maximumDate;
}

#pragma mark - Actions

- (void)dateChanged:(UIDatePicker *)datePicker
{
    self.date = datePicker.date;
}

#pragma mark - Private methods

- (void)updateWithField:(HYPFormField *)field
{
    [super updateWithField:field];

    HYPFieldValue *confirmValue = [HYPFieldValue new];
    confirmValue.title = @"Confirm";
    confirmValue.valueID = [NSDate date];
    confirmValue.value = @YES;

    HYPFieldValue *clearValue = [HYPFieldValue new];
    clearValue.title = @"Clear";
    clearValue.valueID = [NSDate date];
    clearValue.value = @NO;

    field.values = @[confirmValue, clearValue];

    if (field.fieldValue) {
        self.fieldValueLabel.text = [NSDateFormatter localizedStringFromDate:field.fieldValue
                                                                dateStyle:NSDateFormatterMediumStyle
                                                                timeStyle:NSDateFormatterNoStyle];
    } else {
        self.fieldValueLabel.text = nil;
    }
}

- (void)updateContentViewController:(UIViewController *)contentViewController withField:(HYPFormField *)field
{
    self.fieldValuesController.field = self.field;

    if (self.field.subtitle) {
        CGRect frame = self.datePicker.frame;
        frame.origin.y = 50.0f;
        frame.size.height -= 25.0f;
        [self.datePicker setFrame:frame];
    }

    if (self.field.fieldValue) {
        self.datePicker.date = self.field.fieldValue;

        if (self.field.minimumDate) {
            self.datePicker.minimumDate = self.field.minimumDate;
        }

        if (self.field.maximumDate) {
            self.datePicker.maximumDate = self.field.maximumDate;
        }
    }
}

#pragma mark - HYPFieldValuesTableViewControllerDelegate

- (void)fieldValuesTableViewController:(HYPFieldValuesTableViewController *)fieldValuesTableViewController
                      didSelectedValue:(HYPFieldValue *)selectedValue
{
    if ([selectedValue.value boolValue] == YES) {
        self.field.fieldValue = self.datePicker.date;
    } else {
        self.field.fieldValue = nil;
    }

    [self updateWithField:self.field];

    [self validate];

    [self.popoverController dismissPopoverAnimated:YES];

    if ([self.delegate respondsToSelector:@selector(fieldCell:updatedWithField:)]) {
        [self.delegate fieldCell:self updatedWithField:self.field];
    }
}

@end
