#import "HYPDateFormFieldCell.h"

#import "HYPFormTimeViewController.h"

static const CGSize HYPDatePopoverSize = { 320.0f, 272.0f };

@interface HYPDateFormFieldCell () <HYPTextFieldDelegate, HYPFormTimeViewControllerDelegate,
UIPopoverControllerDelegate>

@property (nonatomic, strong) UIPopoverController *popoverController;
@property (nonatomic, strong) HYPFormTimeViewController *timeViewController;

@end

@implementation HYPDateFormFieldCell

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame contentViewController:self.timeViewController
                 andContentSize:HYPDatePopoverSize];
    if (!self) return nil;

    [self.iconButton setImage:[UIImage imageNamed:@"ic_calendar"] forState:UIControlStateNormal];

    return self;
}

#pragma mark - Getters

- (HYPFormTimeViewController *)timeViewController
{
    if (_timeViewController) return _timeViewController;

    _timeViewController = [[HYPFormTimeViewController alloc] initWithDate:[NSDate date]];
    _timeViewController.delegate = self;

    return _timeViewController;
}

#pragma mark - Private methods

- (void)updateWithField:(HYPFormField *)field
{
    [super updateWithField:field];

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
    if (self.field.fieldValue) {
        self.timeViewController.date = self.field.fieldValue;

        if (self.field.minimumDate) {
            self.timeViewController.minimumDate = self.field.minimumDate;
        }

        if (self.field.maximumDate) {
            self.timeViewController.maximumDate = self.field.maximumDate;
        }
    }
}

#pragma mark - HYPTimeViewControllerDelegate

- (void)timeController:(HYPFormTimeViewController *)timeController didChangedDate:(NSDate *)date
{
    self.field.fieldValue = date;

    [self updateWithField:self.field];

    [self validate];

    [self.popoverController dismissPopoverAnimated:YES];

    if ([self.delegate respondsToSelector:@selector(fieldCell:updatedWithField:)]) {
        [self.delegate fieldCell:self updatedWithField:self.field];
    }
}

@end
