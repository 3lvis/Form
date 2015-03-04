#import "FORMDefaultStyle.h"

#import "FORMTextField.h"
#import "FORMFieldHeadingLabel.h"
#import "FORMBackgroundView.h"
#import "FORMSeparatorView.h"
#import "FORMButton.h"
#import "FORMFieldValueLabel.h"

#import "UIColor+Hex.h"

@implementation FORMDefaultStyle

+ (void)applyStyle
{
    [[FORMTextField appearance] setTextColor:[UIColor redColor]];
    [[FORMTextField appearance] setBackgroundColor:[UIColor yellowColor]];

    [[FORMFieldHeadingLabel appearance] setFont:[UIFont fontWithName:@"DIN-Bold" size:14.0]];
    [[FORMFieldHeadingLabel appearance] setTextColor:[UIColor colorFromHex:@"28649C"]];

    [[FORMBackgroundView appearance] setBackgroundColor:[UIColor colorFromHex:@"DAE2EA"]];

    [[FORMSeparatorView appearance] setBackgroundColor:[UIColor colorFromHex:@"C6C6C6"]];

    [[FORMButton appearance] setBackgroundColor:[UIColor colorFromHex:@"3DAFEB"]];
    [[FORMButton appearance] setTitleLabelFont:[UIFont fontWithName:@"DIN-Bold" size:16.0]];
    [[FORMButton appearance] setBorderWidth:1.0f];
    [[FORMButton appearance] setCornerRadius:5.0f];
    [[FORMButton appearance] setHighlightedTitleColor:[UIColor colorFromHex:@"3DAFEB"]];
    [[FORMButton appearance] setBorderColor:[UIColor colorFromHex:@"3DAFEB"]];
    [[FORMButton appearance] setHighlightedBackgroundColor:[UIColor whiteColor]];
    [[FORMButton appearance] setTitleColor:[UIColor whiteColor]];

//    FORMFieldValueCell
//    self.textLabel.font = [UIFont HYPFormsMediumSize];
//    self.textLabel.textColor = [UIColor HYPFormsDarkBlue];
//    self.textLabel.highlightedTextColor = [UIColor whiteColor];
//    self.detailTextLabel.font = [UIFont HYPFormsSmallSize];
//    self.detailTextLabel.textColor = [UIColor HYPFormsDarkBlue];
//    self.detailTextLabel.highlightedTextColor = [UIColor whiteColor];
//    selectedBackgroundView.backgroundColor = [UIColor HYPFormsCallToActionPressed];

    [[FORMTextField appearance] setFont:[UIFont fontWithName:@"DIN-Regular" size:15.0]];
    [[FORMTextField appearance] setTextColor:[UIColor colorFromHex:@"455C73"]];
//    self.layer.borderWidth = FORMFieldCellBorderWidth;
//    self.layer.borderColor = [UIColor HYPFormsBlue].CGColor;
//    self.layer.cornerRadius = FORMFieldCellCornerRadius;
//    if (active) {
//        self.backgroundColor = [UIColor HYPFormsFieldBackgroundActive];
//        self.layer.borderColor = [UIColor HYPFormsBlue].CGColor;
//    } else {
//        self.backgroundColor = [UIColor HYPFormsFieldBackground];
//        self.layer.borderColor = [UIColor HYPFormsBlue].CGColor;
//    }
//    if (enabled) {
//        self.backgroundColor = [UIColor HYPFormsFieldBackground];
//        self.layer.borderColor = [UIColor HYPFormsBlue].CGColor;
//        self.textColor = [UIColor HYPFormsDarkBlue];
//    } else {
//        self.backgroundColor = [UIColor HYPFormsLightGray];
//        self.layer.borderColor = [UIColor HYPFormsFieldDisabledText].CGColor;
//        self.textColor = [UIColor grayColor];
//    }
//    if (valid) {
//        self.backgroundColor = [UIColor HYPFormsFieldBackground];
//        self.layer.borderColor = [UIColor HYPFormsBlue].CGColor;
//    } else {
//        self.backgroundColor = [UIColor HYPFormsFieldBackgroundInvalid];
//        self.layer.borderColor = [UIColor HYPFormsRed].CGColor;
//    }

    [[FORMFieldValueLabel appearance] setFont:[UIFont fontWithName:@"DIN-Regular" size:15.0]];
    [[FORMFieldValueLabel appearance] setTextColor:[UIColor colorFromHex:@"455C73"]];
//    self.layer.borderWidth = FORMFieldCellBorderWidth;
//    self.layer.borderColor = [UIColor HYPFormsBlue].CGColor;
//    self.layer.cornerRadius = FORMFieldCellCornerRadius;
//    if (active) {
//        self.backgroundColor = [UIColor HYPFormsFieldBackgroundActive];
//        self.layer.borderColor = [UIColor HYPFormsBlue].CGColor;
//    } else {
//        self.backgroundColor = [UIColor HYPFormsFieldBackground];
//        self.layer.borderColor = [UIColor HYPFormsBlue].CGColor;
//    }
//    if (enabled) {
//        self.backgroundColor = [UIColor HYPFormsFieldBackground];
//        self.layer.borderColor = [UIColor HYPFormsBlue].CGColor;
//    } else {
//        self.backgroundColor = [UIColor HYPFormsLightGray];
//        self.layer.borderColor = [UIColor HYPFormsFieldDisabledText].CGColor;
//    }
//    if (valid) {
//        self.backgroundColor = [UIColor HYPFormsFieldBackground];
//        self.layer.borderColor = [UIColor HYPFormsBlue].CGColor;
//    } else {
//        self.backgroundColor = [UIColor HYPFormsFieldBackgroundInvalid];
//        self.layer.borderColor = [UIColor HYPFormsRed].CGColor;
//    }

// FORMGroupHeaderView
// _headerLabel.font = [UIFont HYPFormsMediumSize];
// _headerLabel.textColor = [UIColor HYPFormsDarkBlue];

//    FORMFieldValuesTableViewHeader
//    _titleLabel.font = [UIFont HYPFormsMediumSizeBold];
//    _titleLabel.textColor = [UIColor HYPFormsDarkBlue];
//    _subtitleLabel.font = [UIFont HYPFormsMediumSizeLight];
//    _subtitleLabel.textColor = [UIColor HYPFormsCoreBlue];

//    FORMTextFieldCell
//    _subtitleLabel.font = [UIFont HYPFormsSmallSizeMedium];
//    _subtitleLabel.textColor = [UIColor HYPFormsBrown];

}

@end
