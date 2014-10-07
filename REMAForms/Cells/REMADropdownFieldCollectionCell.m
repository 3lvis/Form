//
//  REMADropdownFieldCell.m

//
//  Created by Christoffer Winterkvist on 7/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "REMADropdownFieldCollectionCell.h"

#import "REMADropdownField.h"
#import "REMAObserverCenter.h"

@interface REMADropdownFieldCollectionCell () <REMATextFieldDelegate>

@property (nonatomic, strong) REMADropdownField *dropdownField;

@end

@implementation REMADropdownFieldCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    [self.contentView addSubview:self.dropdownField];

    return self;
}

#pragma mark - Getters

- (REMADropdownField *)dropdownField
{
    if (_dropdownField) return _dropdownField;

    CGRect frame = (CGRect){ .size = self.frame.size };
    _dropdownField = [[REMADropdownField alloc] initWithFrame:frame];
    _dropdownField.delegate = self;
    _dropdownField.alternative = YES;

    return _dropdownField;
}

- (void)updateWithField:(REMAFormField *)field
{
    self.dropdownField.values = field.values;

    if (field.fieldValue) {
        self.dropdownField.selectedValue = [self.dropdownField selectValue:field.fieldValue];
    } else {
        self.dropdownField.selectedValue = [self.dropdownField.values firstObject];
    }

    self.dropdownField.label.text = field.title;

    [[NSNotificationCenter defaultCenter] postNotificationName:REMAFormFieldDidUpdateNotification
                                                        object:self.field];
}

- (void)updateFieldWithCollapsed:(BOOL)collapsed
{
    self.dropdownField.collapsed = collapsed;
}

- (void)updateFieldWithDisabled:(BOOL)disabled
{
    self.dropdownField.disabled = disabled;
}

- (void)validate
{
    self.dropdownField.valid = [self.field isValid];
}

#pragma mark - REMATextFieldDelegate

- (void)textField:(REMATextField *)textField didUpdateWithContent:(id)content
{
    self.field.fieldValue = content;

    [[NSNotificationCenter defaultCenter] postNotificationName:REMAFormFieldDidUpdateNotification
                                                        object:self.field];
}

@end
