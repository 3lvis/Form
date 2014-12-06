@import XCTest;

#import "HYPFormsManager.h"
#import "HYPFormField.h"
#import "HYPFormSection.h"

#import "HYPFormsManager+Tests.h"

@interface HYPFormFieldTests : XCTestCase

@end

@implementation HYPFormFieldTests

- (void)testFieldWithID
{
    NSDictionary *values = @{@"first_name" : @"Elvis", @"last_name" : @"Nunez"};

    HYPFormsManager *manager = [[HYPFormsManager alloc] initWithForms:[HYPFormsManager testForms]];

    HYPFormField *field = [HYPFormField fieldWithID:@"first_name" inForms:manager.forms withIndexPath:NO];
    XCTAssertEqualObjects(field.fieldID, @"first_name");

    [field sectionAndIndexInForms:manager.forms completion:^(BOOL found, HYPFormSection *section, NSInteger index) {
        if (found) {
            [section.fields removeObjectAtIndex:index];
        }
    }];

    field = [HYPFormField fieldWithID:@"first_name" inForms:manager.forms withIndexPath:NO];
    XCTAssertNil(field);
}

@end
