//
//  ChannelServiceTests.swift
//  ChatAppTests
//
//  Created by Dmitrii Zverev on 06.05.2021.
//

@testable import ChatApp
import XCTest

class ChannelsServiceTests: XCTestCase {

    func testCreateChannel() throws {
        // Arrange
        let firebaseManager = FirebaseManagerMock()
        let coreDataStack = CoreDataStackMock()
        let channelService = ChannelsService(
            coreDataStack: coreDataStack,
            firebaseManager: firebaseManager)
        let channelName = "TestChannel"

        // Act
        channelService.createChannel(channelName)

        // Assert
        XCTAssertEqual(firebaseManager.createChannelCallCount, 1)
        XCTAssertEqual(firebaseManager.createChannelName, channelName)
    }

    func testDeleteChannel() {
        // Arrange
        let firebaseManager = FirebaseManagerMock()
        let coreDataStack = CoreDataStackMock()
        let channelService = ChannelsService(
            coreDataStack: coreDataStack,
            firebaseManager: firebaseManager)
        let channelIdentifier = "test-channel-identifier"

        // Act
        channelService.deleteChannel(channelIdentifier)

        // Assert
        XCTAssertEqual(firebaseManager.deleteChannelCallCount, 1)
        XCTAssertEqual(firebaseManager.deleteChannelIdentifier, channelIdentifier)
    }

    func testSubscribeChannelsUpdating() {
        // Arrange
        let firebaseManager = FirebaseManagerMock()
        firebaseManager.documentChanges = []
        let coreDataStack = CoreDataStackMock()
        let channelService = ChannelsService(
            coreDataStack: coreDataStack,
            firebaseManager: firebaseManager)
        let expectation = expectation(description: "subscribeChannelsUpdating")

        // Act
        channelService.subscribeChannelsUpdating {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)

        // Assert
        XCTAssertEqual(firebaseManager.listenChangesChannelListCallCount, 1)
        XCTAssertEqual(coreDataStack.performSaveCallCount, 1)
    }
}
