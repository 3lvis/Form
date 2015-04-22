import UIKit
import XCTest

class FORMFieldValuesTableViewHeaderTests: XCTestCase {

    func testLabelHeight() {
        let formField = FORMField()
        let headerView = FORMFieldValuesTableViewHeader()

        formField.title = "Test"
        formField.info = "Multi-line\nMulti-line"

        let a = headerView.labelHeight()
        let b = CGFloat (68.5)
        XCTAssertEqual(a, b)

        headerView.field = formField

        let c = headerView.labelHeight()
        let d = CGFloat (78.0)
        XCTAssertEqual(c, d)

        formField.info = "Multi-line\nMulti-line\nMulti-line"
        headerView.field = formField

        let f = headerView.labelHeight()
        let g = CGFloat (98.0)
        XCTAssertEqual(f, g)
    }
}
