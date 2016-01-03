#import "FORMCustomStyle.h"

@import Form;
@import FormTextField;
@import Hex;

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

    UIColor *enabledBackgroundColor = [UIColor whiteColor];
    UIColor *enabledBorderColor = [[UIColor alloc] initWithHex:@"FFFFFF"];
    UIColor *enabledTextColor = [[UIColor alloc] initWithHex:@"000000"];
    UIColor *activeBorderColor = [[UIColor alloc] initWithHex:@"BBCEFF"];

    [[FormTextField appearance] setBorderWidth:2];
    [[FormTextField appearance] setCornerRadius:10];
    [[FormTextField appearance] setAccessoryButtonColor:activeBorderColor];
    [[FormTextField appearance] setFont:[UIFont fontWithName:@"Futura-Medium" size:15]];

    [[FormTextField appearance] setEnabledBackgroundColor:enabledBackgroundColor];
    [[FormTextField appearance] setEnabledBorderColor:enabledBorderColor];
    [[FormTextField appearance] setEnabledTextColor:enabledTextColor];

    [[FormTextField appearance] setValidBackgroundColor:enabledBackgroundColor];
    [[FormTextField appearance] setValidBorderColor:enabledBorderColor];
    [[FormTextField appearance] setValidTextColor:enabledTextColor];

    [[FormTextField appearance] setActiveBackgroundColor:enabledBackgroundColor];
    [[FormTextField appearance] setActiveBorderColor:activeBorderColor];
    [[FormTextField appearance] setActiveTextColor:enabledTextColor];

    [[FormTextField appearance] setInactiveBackgroundColor:enabledBackgroundColor];
    [[FormTextField appearance] setInactiveBorderColor:enabledBorderColor];
    [[FormTextField appearance] setInactiveTextColor:enabledTextColor];

    [[FormTextField appearance] setDisabledBackgroundColor:[[UIColor alloc] initWithHex:@"FFFFFF"]];
    [[FormTextField appearance] setDisabledBorderColor:[[UIColor alloc] initWithHex:@"FFFFFF"]];
    [[FormTextField appearance] setDisabledTextColor:[UIColor grayColor]];

    [[FormTextField appearance] setInvalidBackgroundColor:[[UIColor alloc] initWithHex:@"FF4B47"]];
    [[FormTextField appearance] setInvalidBorderColor:[[UIColor alloc] initWithHex:@"FF0600"]];
    [[FormTextField appearance] setInvalidTextColor:[[UIColor alloc] initWithHex:@"FF4B47"]];

    [[FORMGroupHeaderView appearance] setHeaderBackgroundColor:[UIColor clearColor]];

    [[FORMTextFieldCell appearance] setTooltipLabelFont:[UIFont fontWithName:@"Futura-Medium" size:14.0]];
    [[FORMTextFieldCell appearance] setTooltipLabelTextColor:[[UIColor alloc] initWithHex:@"97591D"]];
    [[FORMTextFieldCell appearance] setTooltipBackgroundColor:[[UIColor alloc] initWithHex:@"FDFD54"]];
}

@end
