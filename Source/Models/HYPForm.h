//
//  HYPForm.h
//
//  Created by Elvis Nunez on 08/07/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

@import Foundation;

@class HYPFormField;

@interface HYPForm : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, strong) NSNumber *position;

@property (nonatomic) BOOL shouldValidate;

+ (instancetype)sharedInstance;

- (NSMutableArray *)formsUsingInitialValuesFromDictionary:(NSMutableDictionary *)dictionary
                                                 readOnly:(BOOL)readOnly
                                         additionalValues:(void (^)(NSMutableDictionary *deletedFields,
                                                                    NSMutableDictionary *deletedSections))additionalValues;

- (NSArray *)fields;

- (BOOL)dictionaryIsValid:(NSDictionary *)dictionary;

- (NSInteger)numberOfFields;
- (NSInteger)numberOfFields:(NSMutableDictionary *)deletedSections;

- (void)printFieldValues;

@end
