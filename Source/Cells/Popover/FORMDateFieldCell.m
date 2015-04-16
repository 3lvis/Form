#import "FORMDateFieldCell.h"
#import "FORMFieldValue.h"

static const CGSize FORMDatePopoverSize = { 320.0f, 284.0f };

@interface FORMDateFieldCell () <FORMTextFieldDelegate,
UIPopoverControllerDelegate, FORMFieldValuesTableViewControllerDelegate>

@property (nonatomic) UIDatePicker *datePicker;

@end

@implementation FORMDateFieldCell

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame contentViewController:self.fieldValuesController
                 andContentSize:FORMDatePopoverSize];
    if (!self) return nil;

    self.iconImageView.image = [UIImage imageNamed:@"ic_calendar"];

    self.fieldValuesController.delegate = self;
    self.fieldValuesController.customHeight = 197.0f;
    self.fieldValuesController.tableView.scrollEnabled = NO;
    [self.fieldValuesController.headerView addSubview:self.datePicker];

    return self;
}

#pragma mark - Getters

- (CGRect)datePickerFrame {
    return CGRectMake(0.0f, 25.0f, FORMDatePopoverSize.width, 196);
}

- (UIDatePicker *)datePicker {
    if (_datePicker) return _datePicker;

    _datePicker = [[UIDatePicker alloc] initWithFrame:[self datePickerFrame]];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    _datePicker.backgroundColor = [UIColor clearColor];

    [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];

    return _datePicker;
}

#pragma mark - Setters

- (void)setDate:(NSDate *)date {
    _date = date;

    if (_date) self.datePicker.date = _date;
}

- (void)setMinimumDate:(NSDate *)minimumDate {
    _minimumDate = minimumDate;

    self.datePicker.minimumDate = _minimumDate;
}

- (void)setMaximumDate:(NSDate *)maximumDate {
    _maximumDate = maximumDate;

    self.datePicker.maximumDate = _maximumDate;
}

#pragma mark - Actions

- (void)dateChanged:(UIDatePicker *)datePicker {
    self.date = datePicker.date;
}

#pragma mark - FORMBaseFormFieldCell

- (void)updateWithField:(FORMField *)field {
    [super updateWithField:field];

    FORMFieldValue *confirmValue = [FORMFieldValue new];
    confirmValue.title = NSLocalizedString(@"Confirm", nil);
    confirmValue.valueID = [NSDate date];
    confirmValue.value = @YES;

    FORMFieldValue *clearValue = [FORMFieldValue new];
    clearValue.title = NSLocalizedString(@"Clear", nil);
    clearValue.valueID = [NSDate date];
    clearValue.value = @NO;

    field.values = @[confirmValue, clearValue];

    if (field.value) {
        self.fieldValueLabel.text = [NSDateFormatter localizedStringFromDate:field.value
                                                                   dateStyle:NSDateFormatterMediumStyle
                                                                   timeStyle:NSDateFormatterNoStyle];
    } else {
        self.fieldValueLabel.text = nil;
    }
}

#pragma mark - FORMPopoverFormFieldCell

- (void)updateContentViewController:(UIViewController *)contentViewController withField:(FORMField *)field {
    self.fieldValuesController.field = self.field;

    if (self.field.info) {
        CGRect frame = self.datePicker.frame;
        frame.origin.y = 50.0f;
        frame.size.height -= 25.0f;
        [self.datePicker setFrame:frame];
    }

    if (self.field.value) {
        self.datePicker.date = self.field.value;
    }

    if (self.field.minimumDate) {
        self.datePicker.minimumDate = self.field.minimumDate;
    }

    if (self.field.maximumDate) {
        self.datePicker.maximumDate = self.field.maximumDate;
    }
}

#pragma mark - FORMFieldValuesTableViewControllerDelegate

- (void)fieldValuesTableViewController:(FORMFieldValuesTableViewController *)fieldValuesTableViewController
                      didSelectedValue:(FORMFieldValue *)selectedValue {
    if ([selectedValue.value boolValue] == YES) {
        self.field.value = self.datePicker.date;
    } else {
        self.field.value = nil;
    }

    [self updateWithField:self.field];

    [self validate];

    [self.popoverController dismissPopoverAnimated:YES];

    if ([self.delegate respondsToSelector:@selector(fieldCell:updatedWithField:)]) {
        [self.delegate fieldCell:self updatedWithField:self.field];
    }
}

@end
