//
// HYPFormSection.h
//
//  Created by Elvis Nunez on 10/07/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

@import CoreGraphics;
@import Foundation;

@class HYPForm;
@class HYPFormField;

@interface HYPFormSection : NSObject

@property (nonatomic, strong) NSMutableArray *fields;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSNumber *position;
@property (nonatomic, strong) HYPForm *form;

@property (nonatomic) BOOL shouldValidate;
@property (nonatomic) BOOL containsSpecialField;
@property (nonatomic) BOOL isLast;

@property (nonatomic, strong) NSArray *indexPaths;

+ (HYPFormSection *)sectionWithID:(NSString *)id inForms:(NSArray *)forms;
+ (void)sectionAndIndexForField:(HYPFormField *)field
                        inForms:(NSArray *)forms
                     completion:(void (^)(BOOL found,
                                          HYPFormSection *section,
                                          NSInteger index))completion;

- (NSInteger)indexInForms:(NSArray *)forms;
- (void)removeField:(HYPFormField *)field inForms:(NSArray *)forms;

@end
