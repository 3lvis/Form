//
//  REMADropdownField.h
//  Mine Ansatte
//
//  Created by Christoffer Winterkvist on 7/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "REMATextField.h"
#import "REMAFieldValue.h"

static const NSInteger REMADropdownMaxCellCount = 5;
static const CGFloat REMADropdownFieldCellHeight = 44.0f;

@interface REMADropdownField : REMATextField

@property (nonatomic, strong) NSArray *values;
@property (nonatomic, strong) REMAFieldValue *selectedValue;

- (REMAFieldValue *)selectValue:(NSString *)value;

@end
