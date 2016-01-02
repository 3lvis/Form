#import "FORMDateFieldCell.h"
#import "FORMFieldValue.h"
@import FormTextField;

static const CGSize FORMDatePopoverSize = { 320.0f, 284.0f };

@interface FORMDateFieldCell () <FORMFieldValuesTableViewControllerDelegate>

@property (nonatomic) UIDatePicker *datePicker;

@end

@implementation FORMDateFieldCell

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame contentViewController:self.fieldValuesController
                 andContentSize:FORMDatePopoverSize];
    if (!self) return nil;

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
                                                                   dateStyle:[self dateStyleForField:field]
                                                                   timeStyle:[self timeStyleForField:field]];
    } else {
        self.fieldValueLabel.text = nil;
    }

    self.iconImageView.image = [self fieldIcon];
}

- (NSDateFormatterStyle)dateStyleForField:(FORMField *)field {

    switch (field.type) {
        case FORMFieldTypeDate:
            return NSDateFormatterMediumStyle;
            break;
        case FORMFieldTypeDateTime:
            return NSDateFormatterMediumStyle;
            break;
        default:
            return NSDateFormatterNoStyle;
            break;
    }
}

- (NSDateFormatterStyle)timeStyleForField:(FORMField *)field {

    switch (field.type) {
        case FORMFieldTypeDate:
            return NSDateFormatterNoStyle;
            break;
        case FORMFieldTypeDateTime:
            return NSDateFormatterShortStyle;
            break;
        default:
            return NSDateFormatterShortStyle;
            break;
    }
}

- (UIImage *)fieldIcon {
    NSString *bundlePath = [[[NSBundle bundleForClass:self.class] resourcePath] stringByAppendingPathComponent:@"Form.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath: bundlePath];

    UITraitCollection *trait = [UITraitCollection traitCollectionWithDisplayScale:2.0];

    switch (self.field.type) {
        case FORMFieldTypeDate:
        case FORMFieldTypeDateTime:
            return [UIImage imageNamed:@"calendar"
                                  inBundle:bundle
             compatibleWithTraitCollection:trait];
            break;
        case FORMFieldTypeTime:
            return [UIImage imageNamed:@"clock"
                              inBundle:bundle
         compatibleWithTraitCollection:trait];
            break;
        default:
            return nil;
            break;
    }
}

#pragma mark - FORMPopoverFormFieldCell

- (void)updateContentViewController:(UIViewController *)contentViewController withField:(FORMField *)field {
    self.fieldValuesController.field = self.field;
    
    contentViewController.preferredContentSize = FORMDatePopoverSize;

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

    switch (self.field.type) {
        case FORMFieldTypeDate:
            self.datePicker.datePickerMode = UIDatePickerModeDate;
            break;
        case FORMFieldTypeDateTime:
            self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
            break;
        case FORMFieldTypeTime:
            self.datePicker.datePickerMode = UIDatePickerModeTime;
            break;
        default:
            break;
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

    [fieldValuesTableViewController dismissViewControllerAnimated:YES completion:nil];

    if ([self.delegate respondsToSelector:@selector(fieldCell:updatedWithField:)]) {
        [self.delegate fieldCell:self updatedWithField:self.field];
    }
}

@end
