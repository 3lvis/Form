//
//  NSIndexPath+REMAAdjacent.m
//
//  Created by Elvis Nunez on 08/07/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "NSIndexPath+REMAAdjacent.h"

@implementation NSIndexPath (REMAAdjacent)

- (NSIndexPath *)rema_previousIndexPath
{
    if (self.section == 0 && self.row == 0) return nil;

    NSIndexPath *previousIndexPath;

    if (self.section > 0) {
        if (self.row > 0) {
            previousIndexPath = [NSIndexPath indexPathForRow:self.row - 1 inSection:self.section - 1];
        } else {
            previousIndexPath = [NSIndexPath indexPathForRow:0 inSection:self.section - 1];
        }
    } else {
        previousIndexPath = [NSIndexPath indexPathForRow:self.row - 1 inSection:0];
    }

    return previousIndexPath;
}

@end
