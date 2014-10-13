//
//  HYPFormsCollectionViewController.m

//
//  Created by Elvis Nunez on 03/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "HYPSampleCollectionViewController.h"

#import "HYPFormsCollectionViewDataSource.h"

#import "HYPFieldValue.h"

@interface HYPSampleCollectionViewController () <HYPFormHeaderViewDelegate>

@property (nonatomic, strong) HYPFormsCollectionViewDataSource *dataSource;
@property (nonatomic, copy) NSDictionary *setUpDictionary;

@end

@implementation HYPSampleCollectionViewController

#pragma mark - Deallocation

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:HYPFormFieldDidUpdateNotification
                                                  object:nil];
}

#pragma mark - Initialization

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    HYPFormsLayout *layout = [[HYPFormsLayout alloc] init];
    self = [super initWithCollectionViewLayout:layout];
    if (!self) return nil;

    _setUpDictionary = dictionary;
    layout.dataSource = self.dataSource;

    return self;
}

#pragma mark - Getters

- (HYPFormsCollectionViewDataSource *)dataSource
{
    if (_dataSource) return _dataSource;

    _dataSource = [[HYPFormsCollectionViewDataSource alloc] initWithCollectionView:self.collectionView
                                                                     andDictionary:self.setUpDictionary];

    _dataSource.configureCellBlock = ^(HYPBaseFormFieldCell *cell,
                                       NSIndexPath *indexPath,
                                       HYPFormField *field) {
        cell.field = field;

        if (field.sectionSeparator) {
            cell.backgroundColor = [UIColor colorFromHex:@"C6C6C6"];
        } else {
            cell.backgroundColor = [UIColor clearColor];
        }
    };

    __weak id weakSelf = self;
    _dataSource.configureHeaderViewBlock = ^(HYPFormHeaderView *headerView,
                                             NSString *kind,
                                             NSIndexPath *indexPath,
                                             HYPForm *form) {
        headerView.headerLabel.text = form.title;
        headerView.delegate = weakSelf;
    };

    return _dataSource;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.collectionView.contentInset = UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f);

    self.collectionView.backgroundColor = [UIColor colorFromHex:@"DAE2EA"];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(formFieldDidUpdate:)
                                                 name:HYPFormFieldDidUpdateNotification
                                               object:nil];
}

#pragma mark - HYPFormHeaderViewDelegate

- (void)formHeaderViewWasPressed:(HYPFormHeaderView *)headerView
{
    [self.dataSource collapseFieldsInSection:headerView.section collectionView:self.collectionView];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.dataSource sizeForItemAtIndexPath:indexPath];
}

#pragma mark - Rotation Handling

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];

    [self.collectionViewLayout invalidateLayout];
}

#pragma mark - Observer Actions

- (void)formFieldDidUpdate:(NSNotification *)sender
{
    if ([sender.object isKindOfClass:[HYPFormField class]]) {
        HYPFormField *field = sender.object;

        if ([field.fieldValue isKindOfClass:[HYPFieldValue class]]) {
            HYPFieldValue *value = (HYPFieldValue *)field.fieldValue;
            if (value.fields.count > 0) {
                switch (value.actionType) {
                    case HYPFieldValueActionShow:
                        [self.dataSource showFieldsWithIDs:value.fields];
                        break;
                    case HYPFieldValueActionHide:
                        [self.dataSource deleteFieldsWithIDs:value.fields];
                        break;
                    case HYPFieldValueActionEnable:
                        [self.dataSource enableFieldsWithIDs:value.fields];
                        break;
                    case HYPFieldValueActionDisable:
                        [self.dataSource disableFieldsWithIDs:value.fields];
                        break;
                    case HYPFieldValueActionNone: break;
                }
            }
        }
    }
}

@end
