//
//  SubscribeChannelsUpdatingTest.swift
//  ChatAppTests
//
//  Created by Dmitrii Zverev on 05.05.2021.
//

@testable import ChatApp
import XCTest

class SubscribeChannelsUpdatingTest: XCTestCase {
    func testSubscribeChannelsUpdating() throws {
        // Arrange
        let firebaseManager = FirebaseManagerMock()
        firebaseManager.documentChanges = []

        let coreDataStack = CoreDataStackMock()
        let channelService = ChannelsService(coreDataStack: coreDataStack,
                                             firebaseManager: firebaseManager)
        let expectation = expectation(description: "subscribeChannelsUpdating")

        // Act
        channelService.subscribeChannelsUpdating {
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        // Assets
        XCTAssertEqual(coreDataStack.performSaveCallCount, 1)
    }
}
