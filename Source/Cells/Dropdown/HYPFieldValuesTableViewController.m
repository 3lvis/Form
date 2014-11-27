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
static const CGFloat HYPDropdownHeaderWidth = 320.0f;
static const CGFloat HYPDropdownHeaderHeight = 55.0f;
static const CGFloat HYPDropdownCellHeight = 44.0f;

@interface HYPFieldValuesTableViewController ()

@property (nonatomic, strong) NSArray *values;
@property (nonatomic, strong) NSString *title;

@end

@implementation HYPFieldValuesTableViewController

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;

    self.tableView.rowHeight = HYPDropdownCellHeight;

    return self;
}

#pragma mark - Setters

- (void)setField:(HYPFormField *)field
{
    _field = field;

    self.title = field.title;
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

#pragma mark - Setup

- (UIView *)sectionHeader
{
    CGRect rect = CGRectMake(0, 0, HYPDropdownHeaderWidth, HYPDropdownHeaderHeight);
    UIView *view = [[UIView alloc] initWithFrame:rect];
    UILabel *label = [[UILabel alloc] initWithFrame:rect];

    view.backgroundColor = [UIColor clearColor];
    label.backgroundColor = [UIColor REMALightGray];
    label.text = self.title;
    label.font = [UIFont REMAMediumSizeBold];
    label.textColor = [UIColor REMADarkBlue];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];

    CGRect statusRect = CGRectMake(0,20,HYPDropdownHeaderWidth,HYPDropdownHeaderHeight);
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:statusRect];
    //statusLabel.text = self.title;
    statusLabel.backgroundColor = [UIColor clearColor];
    statusLabel.font = [UIFont REMAMediumSizeLight];
    statusLabel.textColor = [UIColor REMACoreBlue];
    statusLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:statusLabel];

    return view;
}

#pragma mark - TableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return (section == 0) ? [self sectionHeader] : nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HYPDropdownHeaderHeight;
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

        if ([currentFieldValue identifierIsEqualTo:fieldValue.valueID]) {
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
