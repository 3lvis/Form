@import XCTest;

#import "HYPFormsManager.h"
#import "HYPFormField.h"
#import "HYPFormSection.h"

#import "NSJSONSerialization+ANDYJSONFile.h"

@interface HYPFormFieldTests : XCTestCase

@end

@implementation HYPFormFieldTests

- (void)testFieldWithID
{
    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"forms.json"];

    NSDictionary *values = @{@"first_name" : @"Elvis", @"last_name" : @"Nunez"};

    HYPFormsManager *manager = [[HYPFormsManager alloc] initWithJSON:JSON initialValues:values disabledFieldIDs:nil disabled:NO];

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
