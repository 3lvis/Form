//
//  REMATextFieldTypeManager.h
//  REMAForms
//
//  Created by Elvis Nunez on 07/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

@import Foundation;
@import UIKit;

#import "REMATextFormField.h"

@interface REMATextFieldTypeManager : NSObject

- (void)setUpType:(REMATextFieldType)type forTextField:(UITextField *)textField;

@end
