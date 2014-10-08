//
//  REMAFieldValuesTableViewController.m

//
//  Created by Elvis Nunez on 03/09/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "REMAFieldValuesTableViewController.h"

#import "REMABaseTableViewCell.h"
#import "REMAFieldValue.h"
#import "REMAFormField.h"

#import "UIFont+Styles.h"
#import "UIColor+Colors.h"

static NSString * const REMADropdownCellIdentifier = @"REMADropdownCellIdentifier";

@interface REMAFieldValuesTableViewController ()

@property (nonatomic, strong) NSArray *values;

@end

@implementation REMAFieldValuesTableViewController

#pragma mark - Setters

- (void)setField:(REMAFormField *)field
{
    _field = field;

    self.values = [NSArray arrayWithArray:field.values];

    [self.tableView reloadData];
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.clearsSelectionOnViewWillAppear = NO;

    [self.tableView registerClass:[REMABaseTableViewCell class] forCellReuseIdentifier:REMADropdownCellIdentifier];
}

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.values.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:REMADropdownCellIdentifier];

    REMAFieldValue *fieldValue = self.values[indexPath.row];
    cell.textLabel.text = fieldValue.title;

    if ([self.field.fieldValue isEqualToString:fieldValue.title]) {
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    REMAFieldValue *fieldValue = self.values[indexPath.row];

    if ([self.delegate respondsToSelector:@selector(fieldValuesTableViewController:didSelectedValue:)]) {
        [self.delegate fieldValuesTableViewController:self didSelectedValue:fieldValue];
    }
}

@end
