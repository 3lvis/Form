//
// HYPFormSection.h
//
//  Created by Elvis Nunez on 10/07/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

@import CoreGraphics;
@import Foundation;

@class HYPForm;

typedef NS_ENUM(NSInteger, HYPFormSectionType) {
    HYPFormSectionTypeDefault = 0,
    HYPFormSectionTypePicture
};

@interface HYPFormSection : NSObject

@property (nonatomic, strong) NSMutableArray *fields;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSNumber *position;
@property (nonatomic) HYPFormSectionType type;
@property (nonatomic, strong) HYPForm *form;

@property (nonatomic) BOOL shouldValidate;
@property (nonatomic) BOOL containsSpecialField;
@property (nonatomic) BOOL isLast;

@property (nonatomic, strong) NSArray *indexPaths;

- (HYPFormSectionType)typeFromTypeString:(NSString *)typeString;
- (NSUInteger)breakpoints;

@end
