//
//  ProfileViewUITests.swift
//  ChatAppUITests
//
//  Created by Dmitrii Zverev on 06.05.2021.
//

import XCTest

class ProfileViewUITests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    func testExistTextsFields() throws {
        let application = XCUIApplication()
        application.launch()

        let profileIconView = application.otherElements["profileIconView"]
        _ = profileIconView.waitForExistence(timeout: 5.0)
        profileIconView.tap()

        XCTAssertEqual(application.textFields.count, 3)
        XCTAssertTrue(application.textFields["userNameTextField"].exists)
        XCTAssertTrue(application.textFields["userPositionTextField"].exists)
        XCTAssertTrue(application.textFields["userCityTextField"].exists)
    }

}
