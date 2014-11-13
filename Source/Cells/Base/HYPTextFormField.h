//
//  HYPTextField.h

//
//  Created by Elvis Nunez on 07/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

@import UIKit;

#import "HYPInputValidator.h"
#import "HYPFormatter.h"

typedef NS_ENUM(NSInteger, HYPTextFieldType) {
    HYPTextFieldTypeDefault = 0,
    HYPTextFieldTypeName,
    HYPTextFieldTypeUsername,
    HYPTextFieldTypePhoneNumber,
    HYPTextFieldTypeNumber,
    HYPTextFieldTypeFloat,
    HYPTextFieldTypeAddress,
    HYPTextFieldTypeEmail,
    HYPTextFieldTypePassword,
    HYPTextFieldTypeDropdown,
    HYPTextFieldTypeDate,
    HYPTextFieldTypeUnknown
};

@protocol HYPTextFormFieldDelegate;

@interface HYPTextFormField : UITextField

@property (nonatomic, copy) NSString *rawText;

@property (nonatomic, strong) HYPInputValidator *inputValidator;
@property (nonatomic, strong) HYPFormatter *formatter;

@property (nonatomic, copy) NSString *typeString;
@property (nonatomic) HYPTextFieldType type;

@property (nonatomic, getter = isValid)    BOOL valid;
@property (nonatomic, getter = isActive)   BOOL active;

@property (nonatomic, weak) id <HYPTextFormFieldDelegate> formFieldDelegate;

@end

@protocol HYPTextFormFieldDelegate <NSObject>

@optional

- (void)textFormFieldDidBeginEditing:(HYPTextFormField *)textField;

- (void)textFormFieldDidEndEditing:(HYPTextFormField *)textField;

- (void)textFormField:(HYPTextFormField *)textField didUpdateWithText:(NSString *)text;

@end
