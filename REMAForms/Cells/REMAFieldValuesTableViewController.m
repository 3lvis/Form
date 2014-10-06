//
//  REMAFieldValuesTableViewController.m
//  Mine Ansatte
//
//  Created by Elvis Nunez on 03/09/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "REMAFieldValuesTableViewController.h"

#import "REMABaseTableViewCell.h"
#import "REMAFieldValue.h"

#import "UIFont+Styles.h"
#import "UIColor+Colors.h"

static NSString * const REMADropdownCellIdentifier = @"REMADropdownCellIdentifier";

@implementation REMAFieldValuesTableViewController

- (instancetype)initWithValues:(NSArray *)values andSelectedValue:(REMAFieldValue *)selectedValue
{
    self = [super init];
    if (!self) return nil;

    _values = values;
    _selectedValue = selectedValue;

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.clearsSelectionOnViewWillAppear = NO;

    [self.tableView registerClass:[REMABaseTableViewCell class] forCellReuseIdentifier:REMADropdownCellIdentifier];
}

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.values count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:REMADropdownCellIdentifier];
    cell.textLabel.font = [UIFont REMAMediumSize];
    cell.textLabel.textColor = [UIColor remaDarkBlue];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;

    REMAFieldValue *fieldValue = self.values[indexPath.row];
    cell.textLabel.text = fieldValue.title;

    if ([fieldValue.id isEqualToString:self.selectedValue.id]) {
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedValue = self.values[indexPath.row];

    if ([self.delegate respondsToSelector:@selector(fieldValuesTableViewController:didSelectedValue:)]) {
        [self.delegate fieldValuesTableViewController:self didSelectedValue:self.selectedValue];
    }
}

@end
