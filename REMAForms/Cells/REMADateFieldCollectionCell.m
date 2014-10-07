//
//  REMADateFieldCollectionCell.m

//
//  Created by Christoffer Winterkvist on 07/09/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "REMADateFieldCollectionCell.h"

#import "REMADateField.h"
#import "NSDate+REMAISO8601.h"
#import "REMAObserverCenter.h"

@interface REMADateFieldCollectionCell () <REMATextFieldDelegate>

@property (nonatomic, strong) REMADateField *dateField;

@end

@implementation REMADateFieldCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    [self.contentView addSubview:self.dateField];

    return self;
}

#pragma mark - Getters

- (REMADateField *)dateField
{
    if (_dateField) return _dateField;

    CGRect frame = self.frame;
    frame.origin.x = 0.0f;
    frame.origin.y = 0.0f;

    _dateField = [[REMADateField alloc] initWithFrame:frame];
    _dateField.delegate = self;
    _dateField.alternative = YES;

    return _dateField;
}

- (void)updateWithField:(REMAFormField *)field
{
    self.dateField.label.text = field.title;

    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = REMADateFieldFormat;
    self.dateField.text = [formatter stringFromDate:field.fieldValue];
    self.dateField.currentDate = field.fieldValue;

    [[NSNotificationCenter defaultCenter] postNotificationName:REMAFormFieldDidUpdateNotification
                                                        object:self.field];
}

- (void)updateFieldWithDisabled:(BOOL)disabled
{
    self.dateField.disabled = disabled;
}

- (void)updateFieldWithCollapsed:(BOOL)collapsed
{
    self.dateField.collapsed = collapsed;
}

#pragma mark - REMADateFieldDelegate

- (void)textFieldDidUpdate:(REMATextField *)textField
{
    self.field.fieldValue = textField.text;
    [[NSNotificationCenter defaultCenter] postNotificationName:REMAFormFieldDidUpdateNotification
                                                        object:self.field];
}

- (void)validate
{
    self.dateField.valid = [self.field isValid];
}

#pragma mark - REMATextFieldDelegate

- (void)textField:(REMATextField *)textField didUpdateWithContent:(id)content
{
    self.field.fieldValue = content;

    [[NSNotificationCenter defaultCenter] postNotificationName:REMAFormFieldDidUpdateNotification
                                                        object:self.field];
}

@end
