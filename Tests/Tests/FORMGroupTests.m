@import UIKit;
@import XCTest;

#import "FORMGroup.h"
#import "FORMSection.h"

@interface FORMGroupTests : XCTestCase

@end

@implementation FORMGroupTests

- (void)testUpdateSectionsUsingRemovedSectionA
{
    NSArray *sections = @[@{@"id":@"companies",
                            @"type":@"dynamic",
                            @"action_title":@"ADD COMPANY ✛"},
                          @{@"id":@"companies[0]",
                            @"fields":@[
                                    @{@"id":@"companies[0].name",
                                      @"type":@"text",
                                      @"size":@{
                                              @"width":@50,
                                              @"height":@1
                                              }},
                                    @{@"id":@"companies[0].remove",
                                      @"type":@"remove",
                                      @"size":@{
                                              @"width":@20,
                                              @"height":@1
                                              }}
                                    ]},
                          @{@"id":@"companies[1]",
                            @"fields":@[
                                    @{@"id":@"companies[1].name",
                                      @"type":@"text",
                                      @"size":@{
                                              @"width":@50,
                                              @"height":@1
                                              }},
                                    @{@"id":@"companies[1].remove",
                                      @"type":@"remove",
                                      @"size":@{
                                              @"width":@20,
                                              @"height":@1
                                              }}
                                    ]},
                          @{@"id":@"personal-details-0"}];

    FORMGroup *group = [[FORMGroup alloc] initWithDictionary:@{@"id":@"personal-details",
                                                               @"title":@"Personal Details",
                                                               @"sections":sections}
                                                    position:0
                                                    disabled:NO
                                           disabledFieldsIDs:nil];

    XCTAssertEqual(group.sections.count, 4);
    NSArray *sectionPositions = @[@0, @1, @2, @3];
    NSArray *comparedSectionPositions = [group.sections valueForKey:@"position"];
    XCTAssertEqualObjects(sectionPositions, comparedSectionPositions);

    FORMSection *section = group.sections[2];
    XCTAssertEqual(section.sectionID, @"companies[1]");
    NSArray *fieldIDs = [section.fields valueForKey:@"fieldID"];
    NSArray *comparedFieldIDs = @[@"companies[1].name", @"companies[1].remove", @"separator-companies[1]"];
    XCTAssertEqualObjects(fieldIDs, comparedFieldIDs);

    section = group.sections[1];
    [group updateSectionsUsingRemovedSection:section];

    sectionPositions = @[@0, @1, @1, @2];
    comparedSectionPositions = [group.sections valueForKey:@"position"];
    XCTAssertEqualObjects(sectionPositions, comparedSectionPositions);

    section = group.sections[2];
    XCTAssertEqual(section.sectionID, @"companies[0]");
    fieldIDs = [section.fields valueForKey:@"fieldID"];
    comparedFieldIDs = @[@"companies[0].name", @"companies[0].remove", @"separator-companies[0]"];
    XCTAssertEqualObjects(fieldIDs, comparedFieldIDs);

}

- (void)testUpdateSectionsUsingRemovedSectionB
{
    NSArray *sections = @[@{@"id":@"companies",
                            @"type":@"dynamic",
                            @"action_title":@"ADD COMPANY ✛"},
                          @{@"id":@"companies[0]",
                            @"fields":@[
                                    @{@"id":@"companies[0].name",
                                      @"type":@"text",
                                      @"size":@{
                                          @"width":@50,
                                          @"height":@1
                                      }},
                                    @{@"id":@"companies[0].remove",
                                      @"type":@"remove",
                                      @"size":@{
                                              @"width":@20,
                                              @"height":@1
                                              }}
                                    ]},
                          @{@"id":@"personal-details-0"}];

    FORMGroup *group = [[FORMGroup alloc] initWithDictionary:@{@"id":@"personal-details",
                                                               @"title":@"Personal Details",
                                                               @"sections":sections}
                                                    position:0
                                                    disabled:NO
                                           disabledFieldsIDs:nil];

    XCTAssertEqual(group.sections.count, 3);
    NSArray *sectionPositions = @[@0, @1, @2];
    NSArray *comparedSectionPositions = [group.sections valueForKey:@"position"];
    XCTAssertEqualObjects(sectionPositions, comparedSectionPositions);

    FORMSection *section = group.sections[1];
    [group updateSectionsUsingRemovedSection:section];

    sectionPositions = @[@0, @1, @1];
    comparedSectionPositions = [group.sections valueForKey:@"position"];
    XCTAssertEqualObjects(sectionPositions, comparedSectionPositions);
}

@end
