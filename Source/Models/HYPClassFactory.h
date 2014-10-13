//
//  HYPClassFactory.h
//
//  Created by Christoffer Winterkvist on 10/8/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

@import Foundation;

@interface HYPClassFactory : NSObject

+ (Class)classFromString:(NSString *)string withSuffix:(NSString *)suffix;

@end
