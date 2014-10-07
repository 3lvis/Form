//
//  REMADateField.h

//
//  Created by Elvis Nunez on 03/09/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "REMATextField.h"

static const CGSize REMADatePopoverSize = { 320.0f, 216.0f };
static NSString * const REMADateFieldFormat = @"yyyy-MM-dd";

@interface REMADateField : REMATextField <REMATextFieldDelegate>

@property (nonatomic, strong) NSDate *currentDate;

@end
