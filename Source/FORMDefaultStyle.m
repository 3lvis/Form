#import "FORMDefaultStyle.h"

#import "FORMTextField.h"
#import "FORMBackgroundView.h"
#import "FORMSeparatorView.h"
#import "FORMFieldValueLabel.h"
#import "FORMFieldValueCell.h"
#import "FORMGroupHeaderView.h"
#import "FORMFieldValuesTableViewHeader.h"
#import "FORMTextFieldCell.h"
#import "FORMButtonFieldCell.h"
#import "FORMBaseFieldCell.h"

#import "UIColor+Hex.h"

@implementation FORMDefaultStyle

+ (void)applyStyle {
    [[FORMTextField appearance] setTextColor:[UIColor redColor]];
    [[FORMTextField appearance] setBackgroundColor:[UIColor yellowColor]];

    [[FORMBaseFieldCell appearance] setHeadingLabelFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:14.0]];
    [[FORMBaseFieldCell appearance] setHeadingLabelTextColor:[UIColor colorFromHex:@"28649C"]];

    [[FORMBackgroundView appearance] setBackgroundColor:[UIColor colorFromHex:@"DAE2EA"]];

    [[FORMSeparatorView appearance] setBackgroundColor:[UIColor colorFromHex:@"C6C6C6"]];

    [[FORMButtonFieldCell appearance] setBackgroundColor:[UIColor colorFromHex:@"3DAFEB"]];
    [[FORMButtonFieldCell appearance] setTitleLabelFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:16.0]];
    [[FORMButtonFieldCell appearance] setBorderWidth:1.0f];
    [[FORMButtonFieldCell appearance] setCornerRadius:5.0f];
    [[FORMButtonFieldCell appearance] setHighlightedTitleColor:[UIColor colorFromHex:@"3DAFEB"]];
    [[FORMButtonFieldCell appearance] setBorderColor:[UIColor colorFromHex:@"3DAFEB"]];
    [[FORMButtonFieldCell appearance] setHighlightedBackgroundColor:[UIColor whiteColor]];
    [[FORMButtonFieldCell appearance] setTitleColor:[UIColor whiteColor]];

    [[FORMFieldValueCell appearance] setTextLabelFont:[UIFont fontWithName:@"AvenirNext-Medium" size:17.0]];
    [[FORMFieldValueCell appearance] setTextLabelColor:[UIColor colorFromHex:@"455C73"]];
    [[FORMFieldValueCell appearance] setDetailTextLabelHighlightedTextColor:[UIColor whiteColor]];
    [[FORMFieldValueCell appearance] setDetailTextLabelFont:[UIFont fontWithName:@"AvenirNext-Regular" size:14.0]];
    [[FORMFieldValueCell appearance] setDetailTextLabelColor:[UIColor colorFromHex:@"455C73"]];
    [[FORMFieldValueCell appearance] setDetailTextLabelHighlightedTextColor:[UIColor whiteColor]];
    [[FORMFieldValueCell appearance] setSelectedBackgroundViewColor:[UIColor colorFromHex:@"008ED9"]];
    [[FORMFieldValueCell appearance] setSelectedBackgroundFontColor:[UIColor whiteColor]];

    [[FORMTextField appearance] setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:15.0]];
    [[FORMTextField appearance] setTextColor:[UIColor colorFromHex:@"455C73"]];
    [[FORMTextField appearance] setBorderWidth:1.0f];
    [[FORMTextField appearance] setBorderColor:[UIColor colorFromHex:@"3DAFEB"]];
    [[FORMTextField appearance] setCornerRadius:5.0f];
    [[FORMTextField appearance] setActiveBackgroundColor:[UIColor colorFromHex:@"C0EAFF"]];
    [[FORMTextField appearance] setActiveBorderColor:[UIColor colorFromHex:@"3DAFEB"]];
    [[FORMTextField appearance] setInactiveBackgroundColor:[UIColor colorFromHex:@"E1F5FF"]];
    [[FORMTextField appearance] setInactiveBorderColor:[UIColor colorFromHex:@"3DAFEB"]];
    [[FORMTextField appearance] setEnabledBackgroundColor:[UIColor colorFromHex:@"E1F5FF"]];
    [[FORMTextField appearance] setEnabledBorderColor:[UIColor colorFromHex:@"3DAFEB"]];
    [[FORMTextField appearance] setEnabledTextColor:[UIColor colorFromHex:@"455C73"]];
    [[FORMTextField appearance] setDisabledBackgroundColor:[UIColor colorFromHex:@"F5F5F8"]];
    [[FORMTextField appearance] setDisabledBorderColor:[UIColor colorFromHex:@"DEDEDE"]];
    [[FORMTextField appearance] setDisabledTextColor:[UIColor grayColor]];
    [[FORMTextField appearance] setValidBackgroundColor:[UIColor colorFromHex:@"E1F5FF"]];
    [[FORMTextField appearance] setValidBorderColor:[UIColor colorFromHex:@"3DAFEB"]];
    [[FORMTextField appearance] setInvalidBackgroundColor:[UIColor colorFromHex:@"FFD7D7"]];
    [[FORMTextField appearance] setInvalidBorderColor:[UIColor colorFromHex:@"EC3031"]];

    [[FORMFieldValueLabel appearance] setCustomFont:[UIFont fontWithName:@"AvenirNext-Regular" size:15.0]];
    [[FORMFieldValueLabel appearance] setTextColor:[UIColor colorFromHex:@"455C73"]];
    [[FORMFieldValueLabel appearance] setBorderWidth:1.0f];
    [[FORMFieldValueLabel appearance] setBorderColor:[UIColor colorFromHex:@"3DAFEB"]];
    [[FORMFieldValueLabel appearance] setCornerRadius:5.0f];
    [[FORMFieldValueLabel appearance] setActiveBackgroundColor:[UIColor colorFromHex:@"C0EAFF"]];
    [[FORMFieldValueLabel appearance] setActiveBorderColor:[UIColor colorFromHex:@"3DAFEB"]];
    [[FORMFieldValueLabel appearance] setInactiveBackgroundColor:[UIColor colorFromHex:@"E1F5FF"]];
    [[FORMFieldValueLabel appearance] setInactiveBorderColor:[UIColor colorFromHex:@"3DAFEB"]];
    [[FORMFieldValueLabel appearance] setEnabledBackgroundColor:[UIColor colorFromHex:@"E1F5FF"]];
    [[FORMFieldValueLabel appearance] setEnabledBorderColor:[UIColor colorFromHex:@"3DAFEB"]];
    [[FORMFieldValueLabel appearance] setEnabledTextColor:[UIColor colorFromHex:@"455C73"]];
    [[FORMFieldValueLabel appearance] setDisabledBackgroundColor:[UIColor colorFromHex:@"F5F5F8"]];
    [[FORMFieldValueLabel appearance] setDisabledBorderColor:[UIColor colorFromHex:@"DEDEDE"]];
    [[FORMFieldValueLabel appearance] setDisabledTextColor:[UIColor grayColor]];
    [[FORMFieldValueLabel appearance] setValidBackgroundColor:[UIColor colorFromHex:@"E1F5FF"]];
    [[FORMFieldValueLabel appearance] setValidBorderColor:[UIColor colorFromHex:@"3DAFEB"]];
    [[FORMFieldValueLabel appearance] setInvalidBackgroundColor:[UIColor colorFromHex:@"FFD7D7"]];
    [[FORMFieldValueLabel appearance] setInvalidBorderColor:[UIColor colorFromHex:@"EC3031"]];

    [[FORMGroupHeaderView appearance] setHeaderLabelFont:[UIFont fontWithName:@"AvenirNext-Medium" size:17.0]];
    [[FORMGroupHeaderView appearance] setHeaderLabelTextColor:[UIColor colorFromHex:@"455C73"]];
    [[FORMGroupHeaderView appearance] setHeaderBackgroundColor:[UIColor whiteColor]];

    [[FORMFieldValuesTableViewHeader appearance] setTitleLabelFont:[UIFont fontWithName:@"AvenirNext-Medium" size:17.0]];
    [[FORMFieldValuesTableViewHeader appearance] setTitleLabelTextColor:[UIColor colorFromHex:@"455C73"]];
    [[FORMFieldValuesTableViewHeader appearance] setInfoLabelFont:[UIFont fontWithName:@"AvenirNext-UltraLight" size:17.0]];
    [[FORMFieldValuesTableViewHeader appearance] setInfoLabelTextColor:[UIColor colorFromHex:@"28649C"]];

    [[FORMTextFieldCell appearance] setTooltipLabelFont:[UIFont fontWithName:@"AvenirNext-Medium" size:14.0]];
    [[FORMTextFieldCell appearance] setTooltipLabelTextColor:[UIColor colorFromHex:@"97591D"]];
    [[FORMTextFieldCell appearance] setTooltipBackgroundColor:[UIColor colorFromHex:@"FDFD54"]];
}

@end
