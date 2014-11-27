#import "HYPFormTimeViewController.h"

#import "UIColor+REMAColors.h"
#import "UIFont+REMAStyles.m"

static const CGSize HYPDatePopoverSize = { 320.0f, 216.0f };

static CGFloat const HYPDoneButtonX = 10.0f;
static CGFloat const HYPDoneButtonHeight = 45.0f;

@interface HYPFormTimeViewController ()

@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIButton *clearButton;
@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextView *messageTextView;

@end

@implementation HYPFormTimeViewController

#pragma mark - Initialization

- (instancetype)initWithDate:(NSDate *)date
{
    self = [super init];
    if (!self) return nil;

    _date = date;

    return self;
}

#pragma mark - Getters

- (UIDatePicker *)datePicker
{
    if (_datePicker) return _datePicker;

    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0f, 0.0f, HYPDatePopoverSize.width,
                                                                 HYPDatePopoverSize.height)];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    _datePicker.backgroundColor = [UIColor clearColor];

    [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];

    return _datePicker;
}

- (UIButton *)clearButton
{
    if (_clearButton) return _clearButton;

    CGFloat offset = HYPDoneButtonX;
    CGFloat x = HYPDoneButtonX;
    CGFloat y = (self.date) ? CGRectGetMaxY(self.datePicker.frame) : 0.0f;
    y +=  CGRectGetHeight(self.doneButton.frame) + x;
    CGFloat width  = HYPDatePopoverSize.width - (offset * 2);
    CGFloat height = HYPDoneButtonHeight;

    _clearButton = [[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [_clearButton setTitle:NSLocalizedString(@"Clear", nil) forState:UIControlStateNormal];
    [_clearButton setTitleColor:[UIColor REMACoreBlue] forState:UIControlStateNormal];
    _clearButton.backgroundColor = [UIColor whiteColor];
    [_clearButton addTarget:self action:@selector(clearButtonPressed)
           forControlEvents:UIControlEventTouchUpInside];
    _clearButton.layer.cornerRadius = 5.0f;
    _clearButton.titleLabel.font = [UIFont REMALargeSizeRegular];

    return _clearButton;
}

- (UIButton *)doneButton
{
    if (_doneButton) return _doneButton;

    CGFloat offset = HYPDoneButtonX;
    CGFloat x = HYPDoneButtonX;
    CGFloat y = (self.date) ? CGRectGetMaxY(self.datePicker.frame) : 0.0f;
    CGFloat width  = HYPDatePopoverSize.width - (offset * 2);
    CGFloat height = HYPDoneButtonHeight;

    _doneButton = [[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [_doneButton setTitle:NSLocalizedString(@"Done", nil) forState:UIControlStateNormal];
    _doneButton.backgroundColor = [UIColor REMACallToAction];
    [_doneButton addTarget:self action:@selector(doneButtonPressed)
          forControlEvents:UIControlEventTouchUpInside];
    _doneButton.layer.cornerRadius = 5.0f;
    _doneButton.titleLabel.font = [UIFont REMALargeSizeBold];

    return _doneButton;
}

#pragma mark - Setters

- (void)setDate:(NSDate *)date
{
    _date = date;

    self.datePicker.date = _date;
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

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (self.date) {
        [self.view addSubview:self.datePicker];
        [self.datePicker setDate:self.date];
    }

    [self.view addSubview:self.doneButton];
    [self.view addSubview:self.clearButton];
}

#pragma mark - Actions

- (void)dateChanged:(UIDatePicker *)datePicker
{
    self.date = datePicker.date;
}

- (void)doneButtonPressed
{
    if ([self.delegate respondsToSelector:@selector(timeController:didChangedDate:)]) {
        [self.delegate timeController:self didChangedDate:self.datePicker.date];
    }
}

- (void)clearButtonPressed
{
    if ([self.delegate respondsToSelector:@selector(timeController:didChangedDate:)]) {
        [self.delegate timeController:self didChangedDate:nil];
    }
}

@end
