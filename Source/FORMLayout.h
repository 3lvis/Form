@import UIKit;

@protocol FORMLayoutDataSource;

static const NSInteger FORMMarginHorizontal = 15.0f;
static const NSInteger FORMMarginTop = 10.0f;
static const NSInteger FORMMarginBottom = 30.0f;

@interface FORMLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) id <FORMLayoutDataSource> dataSource;

@end

@protocol FORMLayoutDataSource <NSObject>

- (NSArray *)groups;
- (NSArray *)collapsedGroups;

@end
