#import "HYPFieldValuesTableViewController.h"

#import "HYPFieldValue.h"
#import "HYPFormField.h"
#import "HYPFieldValuesTableViewHeader.h"
#import "HYPFieldValueCell.h"

#import "UIFont+REMAStyles.h"
#import "UIColor+REMAColors.h"

static const CGFloat HYPFieldValuesCellHeight = 44.0f;

@interface HYPFieldValuesTableViewController ()

@property (nonatomic, strong) NSArray *values;

@end

@implementation HYPFieldValuesTableViewController

#pragma mark - Getters

- (HYPFieldValuesTableViewHeader *)headerView
{
	if (_headerView) return _headerView;

    _headerView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:HYPFieldValuesTableViewHeaderIdentifier];

	return _headerView;
}

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

    self.tableView.rowHeight = HYPFieldValuesCellHeight;

    [self.tableView registerClass:[HYPFieldValueCell class] forCellReuseIdentifier:HYPFieldValueCellIdentifer];
    [self.tableView registerClass:[HYPFieldValuesTableViewHeader class] forHeaderFooterViewReuseIdentifier:HYPFieldValuesTableViewHeaderIdentifier];
}

#pragma mark - TableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    self.headerView.field = self.field;

    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.customHeight) {
        return self.customHeight;
    } else {
        return (self.field.subtitle) ? HYPFieldValuesHeaderHeight : HYPFieldValuesCellHeight;
    }
}

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.values.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HYPFieldValueCell *cell = [tableView dequeueReusableCellWithIdentifier:HYPFieldValueCellIdentifer];

    HYPFieldValue *fieldValue = self.values[indexPath.row];
    cell.fieldValue = fieldValue;

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
