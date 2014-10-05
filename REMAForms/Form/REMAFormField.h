//
//  REMAFormField.h
//  Mine Ansatte
//
//  Created by Elvis Nunez on 08/07/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

@import UIKit;
@import Foundation;

@class REMAFormSection;

typedef NS_ENUM(NSInteger, REMAFormFieldType) {
    REMAFormFieldTypeDefault = 0,
    REMAFormFieldTypeNone,
    REMAFormFieldTypeSelect,
    REMAFormFieldTypeDate,
    REMAFormFieldTypePicture,
    REMAFormFieldTypeFloat,
    REMAFormFieldTypeNumber
};

@interface REMAFormField : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray *values;
@property (nonatomic, strong) NSNumber *size;
@property (nonatomic, strong) NSNumber *position;
@property (nonatomic, strong) id fieldValue;
@property (nonatomic, strong) NSString *typeString;
@property (nonatomic, strong) NSDictionary *validations;
@property (nonatomic) REMAFormFieldType type;

+ (REMAFormField *)fieldAtIndexPath:(NSIndexPath *)indexPath inSection:(REMAFormSection *)section;

- (REMAFormFieldType)typeFromTypeString:(NSString *)typeString;

- (BOOL)isValid;
- (id)rawFieldValue;
- (id)validator;
- (id)formatter;

@end
