//
//  REMAFormsCollectionViewLayout.m
//  REMAForms
//
//  Created by Elvis Nunez on 10/4/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "REMAFormsCollectionViewLayout.h"

@interface REMAFormsCollectionViewLayout ()

@property (nonatomic, copy) NSArray *items;

@end

@implementation REMAFormsCollectionViewLayout

- (instancetype)initWithItems:(NSArray *)items
{
    self = [super init];
    if (!self) return nil;

    _items = items;

    return self;
}

@end