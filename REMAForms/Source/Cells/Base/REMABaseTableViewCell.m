//
//  REMABaseTableViewCell.m
//  Mine Ansatte
//
//  Created by Christoffer Winterkvist on 8/4/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "REMABaseTableViewCell.h"

#import "UIColor+Colors.h"
#import "UIFont+Styles.h"

@implementation REMABaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (!self) return nil;

	[self configureCell];

	return self;
}

#pragma mark - Setup

- (void)configureCell
{
    self.textLabel.font = [UIFont REMAMediumSize];
    self.textLabel.textColor = [UIColor remaDarkBlue];
    self.textLabel.highlightedTextColor = [UIColor whiteColor];
    self.textLabel.textAlignment = NSTextAlignmentLeft;

    self.selectionStyle = UITableViewCellSelectionStyleGray;
    self.backgroundColor = [UIColor whiteColor];

    UIView *selectedBackgroundView = [[UIView alloc] init];
    selectedBackgroundView.backgroundColor = [UIColor remaCallToActionPressed];
    self.selectedBackgroundView = selectedBackgroundView;
}

@end
