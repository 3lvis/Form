#import "FORMFieldValueCell.h"

#import "FORMFieldValue.h"

@implementation FORMFieldValueCell

#pragma mark - Initializers

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (!self) return nil;

    self.textLabel.textAlignment = NSTextAlignmentLeft;

    self.detailTextLabel.textAlignment = NSTextAlignmentLeft;

    self.selectionStyle = UITableViewCellSelectionStyleGray;
    self.backgroundColor = [UIColor whiteColor];
    self.separatorInset = UIEdgeInsetsZero;

    UIView *selectedBackgroundView = [UIView new];
    self.selectedBackgroundView = selectedBackgroundView;
    self.separatorInset = UIEdgeInsetsZero;

    return self;
}

#pragma mark - Setters

- (void)setFieldValue:(FORMFieldValue *)fieldValue {
    _fieldValue = fieldValue;

    self.textLabel.text = fieldValue.title;

    if (fieldValue.info) {
        self.detailTextLabel.text = fieldValue.info;
    }
}

#pragma mark - Overwritables

- (UIEdgeInsets)layoutMargins {
    return UIEdgeInsetsZero;
}

#pragma mark - Styling

- (void)setTextLabelFont:(UIFont *)font {
    self.textLabel.font = font;
}

- (void)setTextLabelColor:(UIColor *)textColor {
    self.textLabel.textColor = textColor;
}

- (void)setHighlightedTextColor:(UIColor *)highlightedTextColor {
    self.textLabel.highlightedTextColor = highlightedTextColor;
}

- (void)setDetailTextLabelFont:(UIFont *)font {
    self.detailTextLabel.font = font;
}

- (void)setDetailTextLabelColor:(UIColor *)textColor {
    self.detailTextLabel.textColor = textColor;
}

- (void)setDetailTextLabelHighlightedTextColor:(UIColor *)highlightedTextColor {
    self.detailTextLabel.highlightedTextColor = highlightedTextColor;
}

- (void)setSelectedBackgroundViewColor:(UIColor *)backgroundColor {
    self.selectedBackgroundView.backgroundColor = backgroundColor;
}

- (void)setSelectedBackgroundFontColor:(UIColor *)fontColor {
    self.textLabel.highlightedTextColor = fontColor;
}

@end
