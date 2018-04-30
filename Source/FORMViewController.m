#import "FORMViewController.h"

#import "FORMLayout.h"

#import "NSJSONSerialization+ANDYJSONFile.h"
#import "UIViewController+HYPKeyboardToolbar.h"
#import "NSObject+HYPTesting.h"

@interface FORMViewController ()

@property (nonatomic, copy) id JSON;
@property (nonatomic, copy) NSDictionary *initialValues;
@property (nonatomic) FORMDataSource *dataSource;
@property (nonatomic) FORMLayout *layout;
@property (nonatomic) BOOL disabled;

@end

@implementation FORMViewController

#pragma mark - Deallocation

- (void)dealloc {
    [self hyp_removeKeyboardToolbarObservers];
}

#pragma mark - Initialization

- (instancetype)initWithJSON:(id)JSON
            andInitialValues:(NSDictionary *)initialValues
                    disabled:(BOOL)disabled {
    _layout = [FORMLayout new];
    self = [super initWithCollectionViewLayout:_layout];
    if (!self) return nil;

    _JSON = JSON;
    _initialValues = initialValues;
    _disabled = disabled;

    if ([NSObject isUnitTesting]) {
        [self.collectionView numberOfSections];
    }

    self.collectionView.bounces = NO;
    
    [self hyp_addKeyboardToolbarObservers];

    return self;
}

#pragma mark - Getters

- (FORMDataSource *)dataSource {
    if (_dataSource) return _dataSource;

    _dataSource = [[FORMDataSource alloc] initWithJSON:self.JSON
                                        collectionView:self.collectionView
                                                layout:self.layout
                                                values:self.initialValues
                                              disabled:self.disabled];

    return _dataSource;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.collectionView.dataSource = self.dataSource;
}

#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dataSource sizeForFieldAtIndexPath:indexPath];
}

#pragma mark - Rotation Handling

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    [self.view endEditing:YES];

    [self.collectionViewLayout invalidateLayout];
}

@end
