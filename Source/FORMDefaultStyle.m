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
#import "FORMSegmentFieldCell.h"
#import "FORMBaseFieldCell.h"

@import Hex;

@implementation FORMDefaultStyle

+ (void)applyStyle {
    [[FORMTextField appearance] setTextColor:[UIColor redColor]];
    [[FORMTextField appearance] setBackgroundColor:[UIColor yellowColor]];

    [[FORMBaseFieldCell appearance] setHeadingLabelFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:14.0]];
    [[FORMBaseFieldCell appearance] setHeadingLabelTextColor:[[UIColor alloc] initWithHex:@"28649C"]];

    [[FORMBackgroundView appearance] setBackgroundColor:[[UIColor alloc] initWithHex:@"DAE2EA"]];
    [[FORMBackgroundView appearance] setGroupBackgroundColor:[[UIColor alloc] initWithHex:@"DAE2EA"]];
    
    [[FORMSeparatorView appearance] setSeparatorColor:[[UIColor alloc] initWithHex:@"C6C6C6"]];

    [[FORMButtonFieldCell appearance] setBackgroundColor:[[UIColor alloc] initWithHex:@"3DAFEB"]];
    [[FORMButtonFieldCell appearance] setTitleLabelFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:16.0]];
    [[FORMButtonFieldCell appearance] setBorderWidth:1.0f];
    [[FORMButtonFieldCell appearance] setCornerRadius:5.0f];
    [[FORMButtonFieldCell appearance] setHighlightedTitleColor:[[UIColor alloc] initWithHex:@"3DAFEB"]];
    [[FORMButtonFieldCell appearance] setBorderColor:[[UIColor alloc] initWithHex:@"3DAFEB"]];
    [[FORMButtonFieldCell appearance] setHighlightedBackgroundColor:[UIColor whiteColor]];
    [[FORMButtonFieldCell appearance] setTitleColor:[UIColor whiteColor]];

    [[FORMFieldValueCell appearance] setTextLabelFont:[UIFont fontWithName:@"AvenirNext-Medium" size:17.0]];
    [[FORMFieldValueCell appearance] setTextLabelColor:[[UIColor alloc] initWithHex:@"455C73"]];
    [[FORMFieldValueCell appearance] setDetailTextLabelHighlightedTextColor:[UIColor whiteColor]];
    [[FORMFieldValueCell appearance] setDetailTextLabelFont:[UIFont fontWithName:@"AvenirNext-Regular" size:14.0]];
    [[FORMFieldValueCell appearance] setDetailTextLabelColor:[[UIColor alloc] initWithHex:@"455C73"]];
    [[FORMFieldValueCell appearance] setDetailTextLabelHighlightedTextColor:[UIColor whiteColor]];
    [[FORMFieldValueCell appearance] setSelectedBackgroundViewColor:[[UIColor alloc] initWithHex:@"008ED9"]];
    [[FORMFieldValueCell appearance] setSelectedBackgroundFontColor:[UIColor whiteColor]];

    [[FORMTextField appearance] setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:15.0]];
    [[FORMTextField appearance] setTextColor:[[UIColor alloc] initWithHex:@"455C73"]];
    [[FORMTextField appearance] setBorderWidth:1.0f];
    [[FORMTextField appearance] setBorderColor:[[UIColor alloc] initWithHex:@"3DAFEB"]];
    [[FORMTextField appearance] setCornerRadius:5.0f];
    [[FORMTextField appearance] setActiveBackgroundColor:[[UIColor alloc] initWithHex:@"C0EAFF"]];
    [[FORMTextField appearance] setActiveBorderColor:[[UIColor alloc] initWithHex:@"3DAFEB"]];
    [[FORMTextField appearance] setInactiveBackgroundColor:[[UIColor alloc] initWithHex:@"E1F5FF"]];
    [[FORMTextField appearance] setInactiveBorderColor:[[UIColor alloc] initWithHex:@"3DAFEB"]];
    [[FORMTextField appearance] setEnabledBackgroundColor:[[UIColor alloc] initWithHex:@"E1F5FF"]];
    [[FORMTextField appearance] setEnabledBorderColor:[[UIColor alloc] initWithHex:@"3DAFEB"]];
    [[FORMTextField appearance] setEnabledTextColor:[[UIColor alloc] initWithHex:@"455C73"]];
    [[FORMTextField appearance] setDisabledBackgroundColor:[[UIColor alloc] initWithHex:@"F5F5F8"]];
    [[FORMTextField appearance] setDisabledBorderColor:[[UIColor alloc] initWithHex:@"DEDEDE"]];
    [[FORMTextField appearance] setDisabledTextColor:[UIColor grayColor]];
    [[FORMTextField appearance] setValidBackgroundColor:[[UIColor alloc] initWithHex:@"E1F5FF"]];
    [[FORMTextField appearance] setValidBorderColor:[[UIColor alloc] initWithHex:@"3DAFEB"]];
    [[FORMTextField appearance] setInvalidBackgroundColor:[[UIColor alloc] initWithHex:@"FFD7D7"]];
    [[FORMTextField appearance] setInvalidBorderColor:[[UIColor alloc] initWithHex:@"EC3031"]];
    [[FORMTextField appearance] setClearButtonColor:[[UIColor alloc] initWithHex:@"3DAFEB"]];
    [[FORMTextField appearance] setMinusButtonColor:[[UIColor alloc] initWithHex:@"3DAFEB"]];
    [[FORMTextField appearance] setPlusButtonColor:[[UIColor alloc] initWithHex:@"3DAFEB"]];

    [[FORMFieldValueLabel appearance] setCustomFont:[UIFont fontWithName:@"AvenirNext-Regular" size:15.0]];
    [[FORMFieldValueLabel appearance] setTextColor:[[UIColor alloc] initWithHex:@"455C73"]];
    [[FORMFieldValueLabel appearance] setBorderWidth:1.0f];
    [[FORMFieldValueLabel appearance] setBorderColor:[[UIColor alloc] initWithHex:@"3DAFEB"]];
    [[FORMFieldValueLabel appearance] setCornerRadius:5.0f];
    [[FORMFieldValueLabel appearance] setActiveBackgroundColor:[[UIColor alloc] initWithHex:@"C0EAFF"]];
    [[FORMFieldValueLabel appearance] setActiveBorderColor:[[UIColor alloc] initWithHex:@"3DAFEB"]];
    [[FORMFieldValueLabel appearance] setInactiveBackgroundColor:[[UIColor alloc] initWithHex:@"E1F5FF"]];
    [[FORMFieldValueLabel appearance] setInactiveBorderColor:[[UIColor alloc] initWithHex:@"3DAFEB"]];
    [[FORMFieldValueLabel appearance] setEnabledBackgroundColor:[[UIColor alloc] initWithHex:@"E1F5FF"]];
    [[FORMFieldValueLabel appearance] setEnabledBorderColor:[[UIColor alloc] initWithHex:@"3DAFEB"]];
    [[FORMFieldValueLabel appearance] setEnabledTextColor:[[UIColor alloc] initWithHex:@"455C73"]];
    [[FORMFieldValueLabel appearance] setDisabledBackgroundColor:[[UIColor alloc] initWithHex:@"F5F5F8"]];
    [[FORMFieldValueLabel appearance] setDisabledBorderColor:[[UIColor alloc] initWithHex:@"DEDEDE"]];
    [[FORMFieldValueLabel appearance] setDisabledTextColor:[UIColor grayColor]];
    [[FORMFieldValueLabel appearance] setValidBackgroundColor:[[UIColor alloc] initWithHex:@"E1F5FF"]];
    [[FORMFieldValueLabel appearance] setValidBorderColor:[[UIColor alloc] initWithHex:@"3DAFEB"]];
    [[FORMFieldValueLabel appearance] setInvalidBackgroundColor:[[UIColor alloc] initWithHex:@"FFD7D7"]];
    [[FORMFieldValueLabel appearance] setInvalidBorderColor:[[UIColor alloc] initWithHex:@"EC3031"]];

    [[FORMGroupHeaderView appearance] setHeaderLabelFont:[UIFont fontWithName:@"AvenirNext-Medium" size:17.0]];
    [[FORMGroupHeaderView appearance] setHeaderLabelTextColor:[[UIColor alloc] initWithHex:@"455C73"]];
    [[FORMGroupHeaderView appearance] setHeaderBackgroundColor:[UIColor whiteColor]];

    [[FORMFieldValuesTableViewHeader appearance] setInfoLabelFont:[UIFont fontWithName:@"AvenirNext-UltraLight" size:17.0]];
    [[FORMFieldValuesTableViewHeader appearance] setInfoLabelTextColor:[[UIColor alloc] initWithHex:@"28649C"]];

    [[FORMTextFieldCell appearance] setTooltipLabelFont:[UIFont fontWithName:@"AvenirNext-Medium" size:14.0]];
    [[FORMTextFieldCell appearance] setTooltipLabelTextColor:[[UIColor alloc] initWithHex:@"97591D"]];
    [[FORMTextFieldCell appearance] setTooltipBackgroundColor:[[UIColor alloc] initWithHex:@"FDFD54"]];
    
    [[FORMSegmentFieldCell appearance] setLabelFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:16.0]];
    [[FORMSegmentFieldCell appearance] setBackgroundColor:[[UIColor alloc] initWithHex:@"FFFFFF"]];
    [[FORMSegmentFieldCell appearance] setTintColor:[[UIColor alloc] initWithHex:@"3DAFEB"]];

}

@end
