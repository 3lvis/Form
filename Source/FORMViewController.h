@import UIKit;

#import "FORMDataSource.h"

@interface FORMViewController : UICollectionViewController

@property (nonatomic, readonly) FORMDataSource *dataSource;

@property (nonatomic, copy) id JSON;
@property (nonatomic, copy) NSDictionary *initialValues;
@property (nonatomic) BOOL disabled;

- (instancetype)initWithJSON:(id)JSON
            andInitialValues:(NSDictionary *)initialValues
                    disabled:(BOOL)disabled;

@end
