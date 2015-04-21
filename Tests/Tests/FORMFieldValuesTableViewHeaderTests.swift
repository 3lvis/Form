//
//  FORMFieldValuesTableViewHeaderTests.swift
//  Tests
//
//  Created by Christoffer Winterkvist on 4/21/15.
//  Copyright (c) 2015 Hyper. All rights reserved.
//

import UIKit
import XCTest

class FORMFieldValuesTableViewHeaderTests: XCTestCase {

    func testLabelHeight() {
        let formField = FORMField()
        let headerView = FORMFieldValuesTableViewHeader()

        formField.title = "Test"
        formField.info = "Multi-line\nMulti-line"

        XCTAssertEqual(headerView.labelHeight(), CGFloat(68.5))

        headerView.field = formField
        XCTAssertEqual(headerView.labelHeight(), CGFloat(78.0))

        formField.info = "Multi-line\nMulti-line\nMulti-line"
        headerView.field = formField
        XCTAssertEqual(headerView.labelHeight(), CGFloat(98.0))
    }

}
