#import "HYPFieldValuesTableViewController.h"

#import "HYPFieldValue.h"
#import "HYPFormField.h"

#import "UIFont+REMAStyles.h"
#import "UIColor+REMAColors.h"
#import "HYPFieldValueCell.h"

static const CGFloat HYPFieldValuesHeaderWidth = 320.0f;
static const CGFloat HYPFieldValuesHeaderHeight = 66.0f;
static const CGFloat HYPFieldValuesCellHeight = 44.0f;

@interface HYPFieldValuesTableViewController ()

@property (nonatomic, strong) NSArray *values;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;

@end

@implementation HYPFieldValuesTableViewController

#pragma mark - Setters

- (void)setField:(HYPFormField *)field
{
    _field = field;

    self.title = field.title;
    self.subtitle = field.subtitle;
    self.values = [NSArray arrayWithArray:field.values];

    [self.tableView reloadData];
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.clearsSelectionOnViewWillAppear = NO;

    self.tableView.rowHeight = HYPFieldValuesCellHeight;
    self.tableView.backgroundColor = [UIColor REMALightGray];

    [self.tableView registerClass:[HYPFieldValueCell class] forCellReuseIdentifier:HYPFieldValueCellIdentifer];
}

#pragma mark - Setup

- (UIView *)sectionHeader
{
    CGFloat headerHeight = (self.subtitle) ? HYPFieldValuesHeaderHeight : HYPFieldValuesCellHeight;

    CGRect rect = CGRectMake(0, 0, HYPFieldValuesHeaderWidth, headerHeight);
    UIView *view = [[UIView alloc] initWithFrame:rect];

    if (self.subtitle) rect.origin.y -= 10;

    UILabel *label = [[UILabel alloc] initWithFrame:rect];

    view.backgroundColor = [UIColor REMALightGray];
    label.text = self.title;
    label.font = [UIFont REMAMediumSizeBold];
    label.textColor = [UIColor REMADarkBlue];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];

    if (self.subtitle) {
        CGRect statusRect = CGRectMake(0.0f, 15.0f, HYPFieldValuesHeaderWidth, headerHeight);
        UILabel *statusLabel = [[UILabel alloc] initWithFrame:statusRect];
        statusLabel.text = self.subtitle;
        statusLabel.backgroundColor = [UIColor clearColor];
        statusLabel.font = [UIFont REMAMediumSizeLight];
        statusLabel.textColor = [UIColor REMACoreBlue];
        statusLabel.textAlignment = NSTextAlignmentCenter;
        [view addSubview:statusLabel];
    }

    return view;
}

#pragma mark - TableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return (section == 0) ? [self sectionHeader] : nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (self.subtitle) ? HYPFieldValuesHeaderHeight : HYPFieldValuesCellHeight;
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
