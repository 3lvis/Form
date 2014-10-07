//
//  REMAFieldCell.h

//
//  Created by Elvis Nunez on 08/07/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "REMAFormField.h"
#import "REMABaseFieldCollectionCell.h"

static NSString * const REMATextFieldCellIdentifier = @"REMATextFieldCellIdentifier";

@interface REMATextFieldCollectionCell : REMABaseFieldCollectionCell

@property (nonatomic, strong) REMAFormField *field;

@end
