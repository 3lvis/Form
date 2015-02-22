@import UIKit;

@protocol HYPFormsLayoutDataSource;

static const NSInteger FORMMarginHorizontal = 15.0f;
static const NSInteger FORMMarginTop = 10.0f;
static const NSInteger FORMMarginBottom = 30.0f;

@interface FORMCollectionViewLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) id <HYPFormsLayoutDataSource> dataSource;

@end

@protocol HYPFormsLayoutDataSource <NSObject>

- (NSArray *)forms;
- (NSArray *)collapsedForms;

@end
