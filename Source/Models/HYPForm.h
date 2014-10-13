//
//  HYPForm.h
//
//  Created by Elvis Nunez on 08/07/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

@import Foundation;

@interface HYPForm : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, strong) NSNumber *position;

@property (nonatomic) BOOL shouldValidate;

+ (NSMutableArray *)forms;
+ (NSMutableArray *)formsUsingInitialValuesFromDictionary:(NSDictionary *)dictionary;

- (NSArray *)fields;

- (NSInteger)numberOfFields;

- (void)printFieldValues;

@end