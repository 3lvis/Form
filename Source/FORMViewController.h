@import UIKit;

#import "FORMDataSource.h"

@interface FORMViewController : UICollectionViewController

@property (nonatomic, readonly) FORMDataSource *dataSource;

- (instancetype)initWithJSON:(NSArray *)JSON
            andInitialValues:(NSDictionary *)initialValues;

@end
