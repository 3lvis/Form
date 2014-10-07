//
//  REMATextField.h
//  REMAForms
//
//  Created by Elvis Nunez on 07/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

@import UIKit;

#import "REMAInputValidator.h"
#import "REMAFormatter.h"

typedef NS_ENUM(NSInteger, REMATextFieldType) {
    REMATextFieldTypeDefault = 0,
    REMATextFieldTypeName,
    REMATextFieldTypeUsername,
    REMATextFieldTypePhoneNumber,
    REMATextFieldTypeNumber,
    REMATextFieldTypeAddress,
    REMATextFieldTypeEmail,
    REMATextFieldTypePassword,
    REMATextFieldTypeDropdown,
    REMATextFieldTypeDate
};

@protocol REMATextFormFieldDelegate;

@interface REMATextFormField : UITextField

@property (nonatomic, copy) NSString *rawText;

@property (nonatomic, strong) REMAInputValidator *validator;
@property (nonatomic, strong) REMAFormatter *formatter;
@property (nonatomic) REMATextFieldType textFieldType;

@property (nonatomic, getter = isValid)    BOOL valid;
@property (nonatomic, getter = isFailed)   BOOL failed;

@end

@protocol REMATextFormFieldDelegate <NSObject>

@optional

- (void)textField:(REMATextFormField *)textField didUpdateWithContent:(id)content;

@end
