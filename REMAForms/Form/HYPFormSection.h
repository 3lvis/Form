//
// HYPFormSection.h
//
//  Created by Elvis Nunez on 10/07/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

@import CoreGraphics;
@import Foundation;

typedef NS_ENUM(NSInteger, HYPFormSectionType) {
    HYPFormSectionTypeDefault = 0,
    HYPFormSectionTypePicture
};

@interface HYPFormSection : NSObject

@property (nonatomic, strong) NSArray *fields;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSNumber *position;
@property (nonatomic) HYPFormSectionType type;

@property (nonatomic) BOOL shouldValidate;
@property (nonatomic) BOOL containsSpecialField;
@property (nonatomic) BOOL isLast;

- (HYPFormSectionType)typeFromTypeString:(NSString *)typeString;
- (NSUInteger)breakpoints;

@end
