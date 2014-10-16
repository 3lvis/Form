//
//  HYPImageFormFieldCell.m
//  HYPForms
//
//  Created by Elvis Nunez on 10/15/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "HYPImageFormFieldCell.h"

#import "UIColor+ANDYHex.h"
#import "UIFont+REMAStyles.h"
#import "UIColor+REMAColors.h"

@implementation HYPImageFormFieldCell

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    self.contentView.backgroundColor = [UIColor colorFromHex:@"F5F5F8"];

    self.contentView.layer.borderWidth = 1.0f;
    self.contentView.layer.borderColor = [UIColor colorFromHex:@"D5D5D8"].CGColor;
    self.contentView.layer.cornerRadius = 5.0f;
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    [self.contentView addSubview:[self container]];

    return self;
}

- (UIImageView *)cameraImageView
{
    UIImage *image = [UIImage imageNamed:@"camera-icon"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 20.0f, 80.0f, 80.0f)];
    imageView.image = image;

    return imageView;
}

- (UILabel *)label
{
    CGRect labelFrame = CGRectMake(100.0f, 25.0f, 260.0f, 25.0f);
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    label.font = [UIFont REMALargeSize];
    label.textColor = [UIColor REMACoreBlue];
    label.text = NSLocalizedString(@"Legg til bilde av den ansatte", @"Legg til bilde av den ansatte");

    return label;
}

- (UILabel *)info
{
    CGRect infoFrame = CGRectMake(100.0f, 50.0f, 260.0f, 60.0f);
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:infoFrame];
    infoLabel.font = [UIFont REMASmallSize];
    infoLabel.textColor = [UIColor REMACoreBlue];
    infoLabel.text = NSLocalizedString(@"Bildet som lastes opp blir den ansattes profilbilde i ulike REMA-systemer.", @"Bildet som lastes opp blir den ansattes profilbilde i ulike REMA-systemer.");
    infoLabel.lineBreakMode = NSLineBreakByWordWrapping;
    infoLabel.numberOfLines = 0;

    return infoLabel;
}

- (UIView *)container
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 360.0f, 120.0f)];
    [view addSubview:[self cameraImageView]];
    [view addSubview:[self label]];
    [view addSubview:[self info]];
    view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;

    CGPoint center = self.contentView.center;
    center.y -= 10.0f;
    view.center = center;

    return view;
}

#pragma mark - Overwritables

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat horizontalMargin = 10.0f;
    CGFloat verticalMargin = 20.0f;
    CGRect frame = self.frame;
    frame.origin.x = horizontalMargin;
    frame.origin.y = verticalMargin;
    frame.size.width = CGRectGetWidth(self.frame) - (horizontalMargin * 2);
    frame.size.height = CGRectGetHeight(self.frame) - verticalMargin;
    self.contentView.frame = frame;
}

@end
