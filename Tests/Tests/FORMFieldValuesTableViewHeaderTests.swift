import UIKit
import XCTest

class FORMFieldValuesTableViewHeaderTests: XCTestCase {

    func testLabelHeight() {
        let field = FORMField()

        let headerView = FORMFieldValuesTableViewHeader()
        XCTAssertEqualWithAccuracy(headerView.labelHeight, CGFloat(68.5), 0.5, "")

        field.title = "Test"
        field.info = "Multi-line\nMulti-line"
        headerView.field = field
        XCTAssertEqualWithAccuracy(headerView.labelHeight, CGFloat(77.5), 0.5, "")

        field.info = "Multi-line\nMulti-line\nMulti-line"
        headerView.field = field
        XCTAssertEqualWithAccuracy(headerView.labelHeight, CGFloat(97.5), 0.5, "")
    }
}
