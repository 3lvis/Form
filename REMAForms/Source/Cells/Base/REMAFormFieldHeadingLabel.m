//
//  REMAFormFieldHeadingLabel.m

//
//  Created by Elvis Nunez on 07/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "REMAFormFieldHeadingLabel.h"

#import "UIColor+ANDYHex.h"
#import "UIFont+Styles.h"

@implementation REMAFormFieldHeadingLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    self.font = [UIFont REMASmallSize];
    self.textColor = [UIColor colorFromHex:@"28649C"];

    return self;
}

@end
