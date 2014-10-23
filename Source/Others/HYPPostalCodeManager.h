//
//  HYPPostalCodeManager.h
//  HYPForms
//
//  Created by Christoffer Winterkvist on 23/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

@import Foundation;

@interface HYPPostalCodeManager : NSObject

+ (instancetype)sharedManager;
+ (id)JSONObjectWithContentsOfFile:(NSString*)fileName;

- (BOOL)validatePostalCode:(NSString *)postalCode;

@end
