//
//  ChannelServiceTests.swift
//  ChatAppTests
//
//  Created by Dmitrii Zverev on 06.05.2021.
//

@testable import ChatApp
import XCTest
import Firebase

class ChannelsServiceTests: XCTestCase {

    func testCreateChannel() throws {
        // Arrange
        let firebaseManager = FirebaseManagerMock()
        let coreDataStack = CoreDataStackMock()
        let channelService = ChannelsService(coreDataStack: coreDataStack,
                                             firebaseManager: firebaseManager)
        let channelName = "TestChannel"

        // Act
        channelService.createChannel(channelName)

        // Assert
        XCTAssertEqual(firebaseManager.channelName, channelName)
        XCTAssertEqual(firebaseManager.createChannelCallCount, 1)
    }

    func testDeleteChannel() throws {
        // Arrange
        let firebaseManager = FirebaseManagerMock()
        let coreDataStack = CoreDataStackMock()
        let channelService = ChannelsService(coreDataStack: coreDataStack,
                                             firebaseManager: firebaseManager)
        let channelIdentifier = "test-channel-identifier"

        // Act
        channelService.deleteChannel(channelIdentifier)

        // Assert
        XCTAssertEqual(firebaseManager.deleteChannelCallCount, 1)
        XCTAssertEqual(firebaseManager.channelId, channelIdentifier)
    }

    func testSubscribeChannelsUpdating() throws {
        // Arrange
        let firebaseManager = FirebaseManagerMock()
        firebaseManager.documentChanges = [DocumentChange]()
        let coreDataStack = CoreDataStackMock()
        let channelService = ChannelsService(
            coreDataStack: coreDataStack,
            firebaseManager: firebaseManager)
        let expect = expectation(description: "subscribeChannelsUpdating")

        // Act
        channelService.subscribeChannelsUpdating {
            expect.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)

        // Assert
        XCTAssertEqual(firebaseManager.listenChangesChannelListCallCount, 1)
        XCTAssertEqual(coreDataStack.performSaveCallCount, 1)
    }
}
