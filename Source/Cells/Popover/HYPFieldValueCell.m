#import "HYPFieldValueCell.h"

#import "HYPFieldValue.h"

#import "UIFont+HYPFormsStyles.h"
#import "UIColor+HYPFormsColors.h"

@implementation HYPFieldValueCell

#pragma mark - Initializers

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (!self) return nil;

    self.textLabel.font = [UIFont HYPFormsMediumSize];
    self.textLabel.textColor = [UIColor HYPFormsDarkBlue];
    self.textLabel.highlightedTextColor = [UIColor whiteColor];
    self.textLabel.textAlignment = NSTextAlignmentLeft;

    self.detailTextLabel.font = [UIFont HYPFormsSmallSize];
    self.detailTextLabel.textColor = [UIColor HYPFormsDarkBlue];
    self.detailTextLabel.highlightedTextColor = [UIColor whiteColor];
    self.detailTextLabel.textAlignment = NSTextAlignmentLeft;

    self.selectionStyle = UITableViewCellSelectionStyleGray;
    self.backgroundColor = [UIColor whiteColor];
    self.separatorInset = UIEdgeInsetsZero;

    UIView *selectedBackgroundView = [[UIView alloc] init];
    selectedBackgroundView.backgroundColor = [UIColor HYPFormsCallToActionPressed];
    self.selectedBackgroundView = selectedBackgroundView;
    self.separatorInset = UIEdgeInsetsZero;

    return self;
}

#pragma mark - Setters

- (void)setFieldValue:(HYPFieldValue *)fieldValue
{
    _fieldValue = fieldValue;

    self.textLabel.text = fieldValue.title;

    if (fieldValue.subtitle) {
        self.detailTextLabel.text = fieldValue.subtitle;
    }
}

#pragma mark - Overwritables

- (UIEdgeInsets)layoutMargins
{
    return UIEdgeInsetsZero;
}

@end
