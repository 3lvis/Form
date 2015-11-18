#import "FORMViewController.h"

#import "FORMLayout.h"

#import "NSJSONSerialization+ANDYJSONFile.h"
#import "UIViewController+HYPKeyboardToolbar.h"
#import "NSObject+HYPTesting.h"

@interface FORMViewController ()

@property (nonatomic) FORMDataSource *dataSource;
@property (nonatomic) FORMLayout *layout;

@end

@implementation FORMViewController

#pragma mark - Deallocation

- (void)dealloc {
    [self hyp_removeKeyboardToolbarObservers];
}

#pragma mark - Initialization

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
    }

    return self;
}

- (instancetype)initWithJSON:(id)JSON
            andInitialValues:(NSDictionary *)initialValues
                    disabled:(BOOL)disabled {
    _layout = [FORMLayout new];
    self = [super initWithCollectionViewLayout:_layout];
    if (!self) return nil;

    _JSON = JSON;
    _initialValues = initialValues;
    _disabled = disabled;

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

    _layout = (FORMLayout *)self.collectionView.collectionViewLayout;

    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.collectionView.dataSource = self.dataSource;

    self.layout.dataSource = self.dataSource;

    if ([NSObject isUnitTesting]) {
        [self.collectionView numberOfSections];
    }

    [self hyp_addKeyboardToolbarObservers];
}

#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dataSource sizeForFieldAtIndexPath:indexPath];
}

#pragma mark - Rotation Handling

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation
                                   duration:duration];

    [self.view endEditing:YES];

    [self.collectionViewLayout invalidateLayout];
}

@end
