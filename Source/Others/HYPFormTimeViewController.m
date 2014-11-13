#import "HYPFormTimeViewController.h"

#import "UIColor+REMAColors.h"
#import "UIFont+REMAStyles.m"

static const CGSize HYPDatePopoverSize = { 320.0f, 216.0f };

static CGFloat const HYPDoneButtonX = 10.0f;
static CGFloat const HYPDoneButtonHeight = 45.0f;

@interface HYPFormTimeViewController ()

@property (nonatomic, strong) UIDatePicker *datePicker;

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

- (UIButton *)doneButton
{
    if (_doneButton) return _doneButton;

    CGFloat height = HYPDoneButtonHeight;
    CGFloat offset = HYPDoneButtonX;
    CGFloat y = 0.0f;

    if (self.date) y = CGRectGetMaxY(self.datePicker.frame);

    _doneButton = [[UIButton alloc] initWithFrame:CGRectMake(offset, y,
                                                             HYPDatePopoverSize.width - (offset * 2.0f), height)];
    [_doneButton setTitle:NSLocalizedString(@"Done", nil) forState:UIControlStateNormal];
    _doneButton.backgroundColor = [UIColor REMACallToAction];
    [_doneButton addTarget:self action:@selector(doneButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    _doneButton.layer.cornerRadius = 5.0f;
    _doneButton.titleLabel.font = [UIFont REMALargeSizeBold];

    return _doneButton;
}

#pragma mark - Setters

- (void)setDate:(NSDate *)date
{
    _date = date;

    self.datePicker.date = date;
}

- (void)setMinimumDate:(NSDate *)minimumDate
{
    _minimumDate = minimumDate;

    self.datePicker.minimumDate = self.minimumDate;
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

@end
