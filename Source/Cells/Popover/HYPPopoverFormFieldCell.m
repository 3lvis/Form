#import "HYPPopoverFormFieldCell.h"
#import "HYPTextFormFieldCell.h"

static const CGFloat HYPIconButtonWidth = 32.0f;
static const CGFloat HYPIconButtonHeight = 38.0f;

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
    [self.contentView addSubview:self.iconImageView];

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

- (UIImageView *)iconImageView
{
    if (_iconImageView) return _iconImageView;

    _iconImageView = [[UIImageView alloc] initWithFrame:[self frameForIconButton]];
    _iconImageView.contentMode = UIViewContentModeRight;
    _iconImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    return _iconImageView;
}

#pragma mark - Private methods

- (BOOL)becomeFirstResponder
{
    [self titleLabelPressed:self.fieldValueLabel];

    return [super becomeFirstResponder];
}

- (void)validate
{
    [self.fieldValueLabel setValid:[self.field validate]];
}

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
    [super updateWithField:field];
    
    self.iconImageView.hidden = field.disabled;

    self.fieldValueLabel.hidden = (field.sectionSeparator);
    self.fieldValueLabel.enabled = !field.disabled;
    self.fieldValueLabel.userInteractionEnabled = !field.disabled;
    self.fieldValueLabel.valid = field.valid;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.fieldValueLabel.frame = [self frameForFieldValueLabel];
    self.iconImageView.frame = [self frameForIconButton];
}

- (CGRect)frameForFieldValueLabel
{
    CGFloat marginX = HYPTextFormFieldCellMarginX;
    CGFloat marginTop = HYPFormFieldCellMarginTop;
    CGFloat marginBotton = HYPFormFieldCellMarginBottom;

    CGFloat width = CGRectGetWidth(self.frame) - (marginX * 2);
    CGFloat height = CGRectGetHeight(self.frame) - marginTop - marginBotton;
    CGRect frame = CGRectMake(marginX, marginTop, width, height);

    return frame;
}

- (CGRect)frameForIconButton
{
    CGFloat x = CGRectGetWidth(self.frame) - HYPIconButtonWidth - (HYPTextFormFieldCellMarginX * 2);
    CGFloat y = HYPIconButtonHeight - 4;
    CGFloat width = HYPIconButtonWidth;
    CGFloat height = HYPIconButtonHeight;
    CGRect frame = CGRectMake(x, y, width, height);

    return frame;
}

#pragma mark - HYPTitleLabelDelegate

- (void)titleLabelPressed:(HYPFieldValueLabel *)titleLabel
{
    [[NSNotificationCenter defaultCenter] postNotificationName:HYPFormResignFirstResponderNotification object:nil];

    [self updateContentViewController:self.contentViewController withField:self.field];

    if (!self.popoverController.isPopoverVisible) {
        [self.popoverController presentPopoverFromRect:self.bounds
                                                inView:self
                              permittedArrowDirections:UIPopoverArrowDirectionUp | UIPopoverArrowDirectionDown
                                              animated:YES];
    }
}

@end
