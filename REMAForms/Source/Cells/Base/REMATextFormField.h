//
//  REMATextField.h

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

@property (nonatomic, copy) NSString *typeString;
@property (nonatomic) REMATextFieldType type;

@property (nonatomic, getter = isValid)    BOOL valid;

@property (nonatomic, weak) id <REMATextFormFieldDelegate> formFieldDelegate;

@end

@protocol REMATextFormFieldDelegate <NSObject>

@optional

- (void)textFormFieldDidBeginEditing:(REMATextFormField *)textField;

- (void)textFormField:(REMATextFormField *)textField didUpdateWithText:(NSString *)text;

@end
