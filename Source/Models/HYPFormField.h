//
//  HYPFormField.h
//
//  Created by Elvis Nunez on 08/07/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

@import UIKit;
@import Foundation;

@class HYPFormSection;

typedef NS_ENUM(NSInteger, HYPFormFieldType) {
    HYPFormFieldTypeDefault = 0,
    HYPFormFieldTypeNone,
    HYPFormFieldTypeBlank,
    HYPFormFieldTypeSelect,
    HYPFormFieldTypeDate,
    HYPFormFieldTypePicture,
    HYPFormFieldTypeFloat,
    HYPFormFieldTypeNumber
};

static NSString * const HYPFormFieldDidUpdateNotification = @"HYPFormFieldDidUpdateNotification";

@interface HYPFormField : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray *values;
@property (nonatomic, strong) NSNumber *size;
@property (nonatomic, strong) NSNumber *position;
@property (nonatomic, strong) id fieldValue;
@property (nonatomic, strong) NSString *typeString;
@property (nonatomic, strong) NSDictionary *validations;
@property (nonatomic, strong) HYPFormSection *section;
@property (nonatomic) HYPFormFieldType type;
@property (nonatomic) BOOL sectionSeparator;
@property (nonatomic) BOOL disabled;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) NSString *formula;

+ (HYPFormField *)fieldAtIndexPath:(NSIndexPath *)indexPath inSection:(HYPFormSection *)section;

- (HYPFormFieldType)typeFromTypeString:(NSString *)typeString;

- (BOOL)isValid;
- (id)rawFieldValue;
- (id)inputValidator;
- (id)formatter;
- (void)executeFormula;

@end
