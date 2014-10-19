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
    HYPFormFieldTypeNumber,
    HYPFormFieldTypeImage
};

@interface HYPFormField : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSNumber *size;
@property (nonatomic, strong) NSNumber *position;
@property (nonatomic, strong) id fieldValue;
@property (nonatomic, strong) NSString *typeString;
@property (nonatomic) HYPFormFieldType type;
@property (nonatomic, strong) NSArray *values;
@property (nonatomic) BOOL disabled;

@property (nonatomic, strong) NSDictionary *validations;
@property (nonatomic, strong) NSString *formula;
@property (nonatomic, strong) NSArray *targets;

@property (nonatomic, strong) HYPFormSection *section;

@property (nonatomic) BOOL valid;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic) BOOL sectionSeparator;

+ (HYPFormField *)fieldAtIndexPath:(NSIndexPath *)indexPath inSection:(HYPFormSection *)section;

+ (HYPFormField *)fieldWithID:(NSString *)id inForms:(NSArray *)forms withIndexPath:(BOOL)withIndexPath;

- (HYPFormFieldType)typeFromTypeString:(NSString *)typeString;

- (NSInteger)indexInForms:(NSArray *)forms;

- (NSMutableDictionary *)valuesForFormulaInForms:(NSArray *)forms;

- (BOOL)validate;
- (id)rawFieldValue;
- (id)inputValidator;
- (id)formatter;

@end
