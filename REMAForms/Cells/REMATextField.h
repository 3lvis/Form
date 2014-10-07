//
//  REMATextField.h

//
//  Created by Christoffer Winterkvist on 5/13/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "REMABaseField.h"
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

@protocol REMATextFieldDelegate;

@interface REMATextField : REMABaseField <UITextFieldDelegate>

@property (nonatomic, weak) id <REMATextFieldDelegate> delegate;
@property (nonatomic, strong) NSString *rawText;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) REMAInputValidator *validator;
@property (nonatomic, strong) REMAFormatter *formatter;
@property (nonatomic) REMATextFieldType textFieldType;

- (instancetype)initWithFrame:(CGRect)frame;

- (instancetype)initWithFrame:(CGRect)frame
                        label:(NSString *)label;

- (instancetype)initWithFrame:(CGRect)frame
                        label:(NSString *)label
                textFieldType:(REMATextFieldType)textFieldType;

- (instancetype)initWithFrame:(CGRect)frame
                   cornerType:(REMATextFieldCornerType)cornerType;

- (instancetype)initWithFrame:(CGRect)frame
                    validIcon:(UIImage *)validIcon
                textFieldType:(REMATextFieldType)textFieldType
                   cornerType:(REMATextFieldCornerType)cornerType;


- (instancetype)initWithFrame:(CGRect)frame
                        label:(NSString *)label
                   cornerType:(REMATextFieldCornerType)cornerType;

- (instancetype)initWithFrame:(CGRect)frame
                        label:(NSString *)label
                    validIcon:(UIImage *)validIcon
                textFieldType:(REMATextFieldType)textFieldType
                   cornerType:(REMATextFieldCornerType)cornerType;

@end

@protocol REMATextFieldDelegate <NSObject>

@optional

- (BOOL)isValid;
- (void)textFieldDidUpdate:(REMATextField *)textField;
- (void)textFieldDidBeginEditing:(UITextField *)textField;
- (void)textFieldDidEndEditing:(UITextField *)textField;
- (void)textField:(REMATextField *)textField didUpdateWithContent:(id)content;

@end
