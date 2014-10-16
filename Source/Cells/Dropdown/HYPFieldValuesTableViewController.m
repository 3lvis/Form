//
//  HYPFieldValuesTableViewController.m

//
//  Created by Elvis Nunez on 03/09/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "HYPFieldValuesTableViewController.h"

#import "HYPFieldValue.h"
#import "HYPFormField.h"

#import "UIFont+REMAStyles.h"
#import "UIColor+REMAColors.h"

static NSString * const HYPDropdownCellIdentifier = @"HYPDropdownCellIdentifier";

@interface HYPFieldValuesTableViewController ()

@property (nonatomic, strong) NSArray *values;

@end

@implementation HYPFieldValuesTableViewController

#pragma mark - Setters

- (void)setField:(HYPFormField *)field
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

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:HYPDropdownCellIdentifier];
}

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.values.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HYPDropdownCellIdentifier];
    cell.textLabel.font = [UIFont REMAMediumSize];
    cell.textLabel.textColor = [UIColor REMADarkBlue];
    cell.textLabel.highlightedTextColor = [UIColor whiteColor];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;

    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.backgroundColor = [UIColor whiteColor];

    UIView *selectedBackgroundView = [[UIView alloc] init];
    selectedBackgroundView.backgroundColor = [UIColor REMACallToActionPressed];
    cell.selectedBackgroundView = selectedBackgroundView;

    HYPFieldValue *fieldValue = self.values[indexPath.row];
    cell.textLabel.text = fieldValue.title;

    if ([self.field.fieldValue isKindOfClass:[HYPFieldValue class]]) {
        HYPFieldValue *currentFieldValue = self.field.fieldValue;

        if ([currentFieldValue identifierIsEqualTo:fieldValue.id]) {
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    } else {
        if ([fieldValue identifierIsEqualTo:self.field.fieldValue]) {
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HYPFieldValue *fieldValue = self.values[indexPath.row];

    if ([self.delegate respondsToSelector:@selector(fieldValuesTableViewController:didSelectedValue:)]) {
        [self.delegate fieldValuesTableViewController:self didSelectedValue:fieldValue];
    }
}

@end
