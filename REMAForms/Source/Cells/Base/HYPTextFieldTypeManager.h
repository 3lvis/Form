//
//  REMATextFieldTypeManager.h

//
//  Created by Elvis Nunez on 07/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

@import Foundation;
@import UIKit;

#import "HYPTextFormField.h"

@interface HYPTextFieldTypeManager : NSObject

- (void)setUpType:(REMATextFieldType)type forTextField:(UITextField *)textField;

@end
