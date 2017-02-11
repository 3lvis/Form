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
    [[FORMBaseFieldCell appearance] setHeadingLabelTextColor:[[UIColor alloc] initWithHex:@"BBCEFF"]];

    [[FORMBackgroundView appearance] setBackgroundColor:[UIColor clearColor]];
    [[FORMBackgroundView appearance] setGroupBackgroundColor:[UIColor redColor]];

    [[FORMButtonFieldCell appearance] setBackgroundColor:[[UIColor alloc] initWithHex:@"3DAFEB"]];
    [[FORMButtonFieldCell appearance] setTitleLabelFont:[UIFont fontWithName:@"Futura-Medium" size:16.0]];
    [[FORMButtonFieldCell appearance] setBorderWidth:1.0f];
    [[FORMButtonFieldCell appearance] setCornerRadius:20.0f];
    [[FORMButtonFieldCell appearance] setTitleColor:[UIColor whiteColor]];
    [[FORMButtonFieldCell appearance] setHighlightedTitleColor:[UIColor whiteColor]];
    [[FORMButtonFieldCell appearance] setHighlightedBackgroundColor:[[UIColor alloc] initWithHex:@"0079B9"]];

    [[FORMTextField appearance] setFont:[UIFont fontWithName:@"Futura-Medium" size:15.0]];
    [[FORMTextField appearance] setTextColor:[[UIColor alloc] initWithHex:@"000000"]];
    [[FORMTextField appearance] setBorderWidth:2.0f];
    [[FORMTextField appearance] setBorderColor:[[UIColor alloc] initWithHex:@"FFFFFF"]];
    [[FORMTextField appearance] setCornerRadius:20.0f];

    [[FORMTextField appearance] setActiveBackgroundColor:[[UIColor alloc] initWithHex:@"FFFFFF"]];
    [[FORMTextField appearance] setActiveBorderColor:[[UIColor alloc] initWithHex:@"BBCEFF"]];

    [[FORMTextField appearance] setInactiveBackgroundColor:[[UIColor alloc] initWithHex:@"FFFFFF"]];
    [[FORMTextField appearance] setInactiveBorderColor:[[UIColor alloc] initWithHex:@"FFFFFF"]];

    [[FORMTextField appearance] setEnabledBackgroundColor:[[UIColor alloc] initWithHex:@"FFFFFF"]];
    [[FORMTextField appearance] setEnabledBorderColor:[[UIColor alloc] initWithHex:@"FFFFFF"]];
    [[FORMTextField appearance] setEnabledTextColor:[[UIColor alloc] initWithHex:@"000000"]];

    [[FORMTextField appearance] setDisabledBackgroundColor:[[UIColor alloc] initWithHex:@"FFFFFF"]];
    [[FORMTextField appearance] setDisabledBorderColor:[[UIColor alloc] initWithHex:@"FFFFFF"]];
    [[FORMTextField appearance] setDisabledTextColor:[UIColor grayColor]];

    [[FORMTextField appearance] setValidBackgroundColor:[[UIColor alloc] initWithHex:@"FFFFFF"]];
    [[FORMTextField appearance] setValidBorderColor:[[UIColor alloc] initWithHex:@"FFFFFF"]];

    [[FORMTextField appearance] setInvalidBackgroundColor:[[UIColor alloc] initWithHex:@"FF4B47"]];
    [[FORMTextField appearance] setInvalidBorderColor:[[UIColor alloc] initWithHex:@"FF0600"]];

    [[FORMGroupHeaderView appearance] setHeaderBackgroundColor:[UIColor clearColor]];

    [[FORMTextFieldCell appearance] setTooltipLabelFont:[UIFont fontWithName:@"Futura-Medium" size:14.0]];
    [[FORMTextFieldCell appearance] setTooltipLabelTextColor:[[UIColor alloc] initWithHex:@"97591D"]];
    [[FORMTextFieldCell appearance] setTooltipBackgroundColor:[[UIColor alloc] initWithHex:@"FDFD54"]];
}

@end
