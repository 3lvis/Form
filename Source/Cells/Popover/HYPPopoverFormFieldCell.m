#import "HYPPopoverFormFieldCell.h"

static const CGFloat HYPTextFormFieldIconWidth = 32.0f;
static const CGFloat HYPTextFormFieldIconHeight = 38.0f;

static const CGFloat HYPTextFormFieldCellTextFieldMarginTop = 30.0f;
static const CGFloat HYPTextFormFieldCellTextFieldMarginBottom = 10.0f;

@interface HYPPopoverFormFieldCell () <HYPTitleLabelDelegate, UIPopoverControllerDelegate>

@property (nonatomic, strong) UIViewController *contentViewController;
@property (nonatomic) CGSize contentSize;

@end

@implementation HYPPopoverFormFieldCell

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame contentViewController:(UIViewController *)contentViewController
               andContentSize:(CGSize)contentSize
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    _contentViewController = contentViewController;
    _contentSize = contentSize;

    [self.contentView addSubview:self.fieldValueLabel];
    [self.contentView addSubview:self.iconButton];

    return self;
}

#pragma mark - Getters

- (HYPFieldValueLabel *)fieldValueLabel
{
    if (_fieldValueLabel) return _fieldValueLabel;

    _fieldValueLabel = [[HYPFieldValueLabel alloc] initWithFrame:[self frameForFieldValueLabel]];
    _fieldValueLabel.delegate = self;

    return _fieldValueLabel;
}

- (UIPopoverController *)popoverController
{
    if (_popoverController) return _popoverController;

    _popoverController = [[UIPopoverController alloc] initWithContentViewController:self.contentViewController];
    _popoverController.delegate = self;
    _popoverController.popoverContentSize = self.contentSize;
    _popoverController.backgroundColor = [UIColor whiteColor];

    return _popoverController;
}

- (UIButton *)iconButton
{
    if (_iconButton) return _iconButton;

    _iconButton = [[UIButton alloc] initWithFrame:[self frameForIconButton]];
    _iconButton.contentMode = UIViewContentModeRight;
    _iconButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    return _iconButton;
}

#pragma mark - Private methods

- (void)updateContentViewController:(UIViewController *)contentViewController withField:(HYPFormField *)field
{
    abort();
}

- (void)updateFieldWithDisabled:(BOOL)disabled
{
    self.fieldValueLabel.enabled = !disabled;
}

- (void)updateWithField:(HYPFormField *)field
{
    self.iconButton.hidden = field.disabled;

    self.fieldValueLabel.hidden         = (field.sectionSeparator);
    self.fieldValueLabel.enabled        = !field.disabled;
    self.fieldValueLabel.valid          = field.valid;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.fieldValueLabel.frame = [self frameForFieldValueLabel];
    self.iconButton.frame = [self frameForIconButton];
}

- (CGRect)frameForFieldValueLabel
{
    CGFloat marginX = HYPTextFormFieldCellMarginX;
    CGFloat marginTop = HYPTextFormFieldCellTextFieldMarginTop;
    CGFloat marginBotton = HYPTextFormFieldCellTextFieldMarginBottom;

    CGFloat width = CGRectGetWidth(self.frame) - (marginX * 2);
    CGFloat height = CGRectGetHeight(self.frame) - marginTop - marginBotton;
    CGRect frame = CGRectMake(marginX, marginTop, width, height);

    return frame;
}

- (CGRect)frameForIconButton
{
    CGFloat x = CGRectGetWidth(self.frame) - HYPTextFormFieldIconWidth - HYPTextFormFieldCellMarginX;
    CGFloat y = HYPTextFormFieldIconHeight - 4;
    CGFloat width = HYPTextFormFieldIconWidth;
    CGFloat height = HYPTextFormFieldIconHeight;
    CGRect frame = CGRectMake(x, y, width, height);

    return frame;
}

#pragma mark - HYPTitleLabelDelegate

- (void)titleLabelPressed:(HYPFieldValueLabel *)titleLabel
{
    [self updateContentViewController:self.contentViewController withField:self.field];

    if (!self.popoverController.isPopoverVisible) {
        [self.popoverController presentPopoverFromRect:self.bounds
                                                inView:self
                              permittedArrowDirections:UIPopoverArrowDirectionUp | UIPopoverArrowDirectionDown
                                              animated:YES];
    }
}

@end
