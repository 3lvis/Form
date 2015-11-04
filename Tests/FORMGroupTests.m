@import UIKit;
@import XCTest;

#import "FORMDataSource.h"
#import "FORMGroup.h"
#import "FORMSection.h"

#import "NSDictionary+ANDYSafeValue.h"
#import "NSJSONSerialization+ANDYJSONFile.h"

@interface FORMDataSource ()

- (FORMGroup *)groupWithID:(NSString *)groupID;

- (BOOL)groupIsCollapsed:(NSInteger)group;

- (void)collapseFieldsInGroup:(NSInteger)group
               collectionView:(UICollectionView *)collectionView;

@end

@interface FORMGroupTests : XCTestCase

@end

@implementation FORMGroupTests

- (void)testCollapsedGroups {
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"forms.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMLayout *layout = [FORMLayout new];

    FORMDataSource *dataSource = [[FORMDataSource alloc] initWithJSON:JSON
                                                       collectionView:nil
                                                               layout:layout
                                                               values:nil
                                                             disabled:NO];

    FORMGroup *group = [dataSource groupWithID:@"personal-details"];

    [dataSource collapseFieldsInGroup:[group.position integerValue] collectionView:nil];
    XCTAssertTrue([dataSource groupIsCollapsed:[group.position integerValue]]);

    [dataSource collapseFieldsInGroup:[group.position integerValue] collectionView:nil];
    XCTAssertFalse([dataSource groupIsCollapsed:[group.position integerValue]]);

}

- (void)testPreCollapsedGroups {
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"collapsed-groups.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMLayout *layout = [FORMLayout new];

    FORMDataSource *dataSource = [[FORMDataSource alloc] initWithJSON:JSON
                                                       collectionView:nil
                                                               layout:layout
                                                               values:nil
                                                             disabled:NO];

    FORMGroup *group = [dataSource groupWithID:@"personal-details"];
    XCTAssertTrue([dataSource groupIsCollapsed:[group.position integerValue]]);
}

- (void)testCollapsibilityOfGroups {
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"collapsed-groups.json"
                                                             inBundle:[NSBundle bundleForClass:[self class]]];

    FORMLayout *layout = [FORMLayout new];

    FORMDataSource *dataSource = [[FORMDataSource alloc] initWithJSON:JSON
                                                       collectionView:nil
                                                               layout:layout
                                                               values:nil
                                                             disabled:NO];

    FORMGroup *group = [dataSource groupWithID:@"personal-details"];
    XCTAssertTrue([dataSource groupIsCollapsed:[group.position integerValue]]);
    XCTAssertTrue(group.collapsible);
    
    group = [dataSource groupWithID:@"employment"];
    XCTAssertFalse([dataSource groupIsCollapsed:[group.position integerValue]]);
    XCTAssertFalse(group.collapsible);
}

@end
