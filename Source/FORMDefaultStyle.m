#import "FORMDefaultStyle.h"

#import "FORMTextField.h"
#import "FORMFieldHeadingLabel.h"
#import "FORMBackgroundView.h"
#import "FORMSeparatorView.h"
#import "FORMButton.h"
#import "FORMFieldValueLabel.h"
#import "FORMFieldValueCell.h"

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

    [[FORMFieldValueCell appearance] setTextLabelFont:[UIFont fontWithName:@"DIN-Medium" size:17.0]];
    [[FORMFieldValueCell appearance] setTextLabelColor:[UIColor colorFromHex:@"455C73"]];
    [[FORMFieldValueCell appearance] setDetailTextLabelHighlightedTextColor:[UIColor whiteColor]];
    [[FORMFieldValueCell appearance] setDetailTextLabelFont:[UIFont fontWithName:@"DIN-Regular" size:14.0]];
    [[FORMFieldValueCell appearance] setDetailTextLabelColor:[UIColor colorFromHex:@"455C73"]];
    [[FORMFieldValueCell appearance] setDetailTextLabelHighlightedTextColor:[UIColor whiteColor]];
    [[FORMFieldValueCell appearance] setSelectedBackgroundViewColor:[UIColor colorFromHex:@"008ED9"]];

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
