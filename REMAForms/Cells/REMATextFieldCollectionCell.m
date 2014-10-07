//
//  REMAFieldCell.m

//
//  Created by Elvis Nunez on 08/07/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "REMATextFieldCollectionCell.h"

#import "REMATextField.h"
#import "REMAInputValidator.h"
#import "REMAFormatter.h"
#import "REMAObserverCenter.h"

@interface REMATextFieldCollectionCell () <REMATextFieldDelegate>

@property (nonatomic, strong) REMATextField *textField;

@end

@implementation REMATextFieldCollectionCell

#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    [self.contentView addSubview:self.textField];

    return self;
}

#pragma mark - Getters

- (REMATextField *)textField
{
    if (_textField) return _textField;

    CGRect frame = self.frame;
    frame.origin.x = 0.0f;
    frame.origin.y = 0.0f;
    _textField = [[REMATextField alloc] initWithFrame:frame];
    _textField.delegate = self;
    _textField.alternative = YES;

    return _textField;
}

#pragma mark - Setters

- (void)updateWithField:(REMAFormField *)field
{
    [self setTypeWithJSONValue:field.typeString];

    self.textField.validator = [self.field validator];
    self.textField.formatter = [self.field formatter];
    self.textField.label.text = field.title;
    self.textField.rawText = field.fieldValue;
}

- (void)updateFieldWithCollapsed:(BOOL)collapsed
{
    self.textField.collapsed = collapsed;
}

- (void)updateFieldWithDisabled:(BOOL)disabled
{
    self.textField.disabled = disabled;
}

#pragma mark - Private methods

- (void)setTypeWithJSONValue:(NSString *)type
{
    REMATextFieldType textFieldType;
    if ([type isEqualToString:@"name"]) {
        textFieldType = REMATextFieldTypeName;
    } else if ([type isEqualToString:@"username"]) {
        textFieldType = REMATextFieldTypeUsername;
    } else if ([type isEqualToString:@"phone"]) {
        textFieldType = REMATextFieldTypePhoneNumber;
    } else if ([type isEqualToString:@"number"]) {
        textFieldType = REMATextFieldTypeNumber;
    } else if ([type isEqualToString:@"address"]) {
        textFieldType = REMATextFieldTypeAddress;
    } else if ([type isEqualToString:@"email"]) {
        textFieldType = REMATextFieldTypeEmail;
    } else if ([type isEqualToString:@"date"]) {
        textFieldType = REMATextFieldTypeDate;
    } else {
        textFieldType = REMATextFieldTypeDefault;
    }

    [self.textField setTextFieldType:textFieldType];
}

#pragma mark - REMATextFieldDelegate

- (void)textFieldDidUpdate:(REMATextField *)textField
{
    textField.rawText = textField.text;
    self.field.fieldValue = textField.rawText;

    [[NSNotificationCenter defaultCenter] postNotificationName:REMAFormFieldDidUpdateNotification
                                                        object:self.field];
}

- (void)validate
{
    self.field.fieldValue = self.textField.rawText;
    self.textField.valid = [self.field isValid];
}

@end
