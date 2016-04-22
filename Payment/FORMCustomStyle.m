#import "FORMCustomStyle.h"

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
#import "FORMTextField.h"

#import "UIColor+Hex.h"

@implementation FORMCustomStyle

+ (void)applyStyle {
    [[FORMBaseFieldCell appearance] setHeadingLabelFont:[UIFont fontWithName:@"Futura-Medium" size:15.0]];
    [[FORMBaseFieldCell appearance] setHeadingLabelTextColor:[UIColor form_colorFromHex:@"BBCEFF"]];

    [[FORMBackgroundView appearance] setBackgroundColor:[UIColor clearColor]];
    [[FORMBackgroundView appearance] setGroupBackgroundColor:[UIColor redColor]];

    [[FORMButtonFieldCell appearance] setBackgroundColor:[UIColor form_colorFromHex:@"3DAFEB"]];
    [[FORMButtonFieldCell appearance] setTitleLabelFont:[UIFont fontWithName:@"Futura-Medium" size:16.0]];
    [[FORMButtonFieldCell appearance] setBorderWidth:1.0f];
    [[FORMButtonFieldCell appearance] setCornerRadius:20.0f];
    [[FORMButtonFieldCell appearance] setTitleColor:[UIColor whiteColor]];
    [[FORMButtonFieldCell appearance] setHighlightedTitleColor:[UIColor whiteColor]];
    [[FORMButtonFieldCell appearance] setHighlightedBackgroundColor:[UIColor form_colorFromHex:@"0079B9"]];

    [[FORMTextField appearance] setFont:[UIFont fontWithName:@"Futura-Medium" size:15.0]];
    [[FORMTextField appearance] setTextColor:[UIColor form_colorFromHex:@"000000"]];
    [[FORMTextField appearance] setBorderWidth:2.0f];
    [[FORMTextField appearance] setBorderColor:[UIColor form_colorFromHex:@"FFFFFF"]];
    [[FORMTextField appearance] setCornerRadius:20.0f];

    [[FORMTextField appearance] setActiveBackgroundColor:[UIColor form_colorFromHex:@"FFFFFF"]];
    [[FORMTextField appearance] setActiveBorderColor:[UIColor form_colorFromHex:@"BBCEFF"]];

    [[FORMTextField appearance] setInactiveBackgroundColor:[UIColor form_colorFromHex:@"FFFFFF"]];
    [[FORMTextField appearance] setInactiveBorderColor:[UIColor form_colorFromHex:@"FFFFFF"]];

    [[FORMTextField appearance] setEnabledBackgroundColor:[UIColor form_colorFromHex:@"FFFFFF"]];
    [[FORMTextField appearance] setEnabledBorderColor:[UIColor form_colorFromHex:@"FFFFFF"]];
    [[FORMTextField appearance] setEnabledTextColor:[UIColor form_colorFromHex:@"000000"]];

    [[FORMTextField appearance] setDisabledBackgroundColor:[UIColor form_colorFromHex:@"FFFFFF"]];
    [[FORMTextField appearance] setDisabledBorderColor:[UIColor form_colorFromHex:@"FFFFFF"]];
    [[FORMTextField appearance] setDisabledTextColor:[UIColor grayColor]];

    [[FORMTextField appearance] setValidBackgroundColor:[UIColor form_colorFromHex:@"FFFFFF"]];
    [[FORMTextField appearance] setValidBorderColor:[UIColor form_colorFromHex:@"FFFFFF"]];

    [[FORMTextField appearance] setInvalidBackgroundColor:[UIColor form_colorFromHex:@"FF4B47"]];
    [[FORMTextField appearance] setInvalidBorderColor:[UIColor form_colorFromHex:@"FF0600"]];

    [[FORMGroupHeaderView appearance] setHeaderBackgroundColor:[UIColor clearColor]];

    [[FORMTextFieldCell appearance] setTooltipLabelFont:[UIFont fontWithName:@"Futura-Medium" size:14.0]];
    [[FORMTextFieldCell appearance] setTooltipLabelTextColor:[UIColor form_colorFromHex:@"97591D"]];
    [[FORMTextFieldCell appearance] setTooltipBackgroundColor:[UIColor form_colorFromHex:@"FDFD54"]];
}

@end
