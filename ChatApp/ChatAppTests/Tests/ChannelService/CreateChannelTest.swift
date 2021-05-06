//
//  CreateChannelTest.swift
//  ChatAppTests
//
//  Created by Dmitrii Zverev on 04.05.2021.
//

import XCTest

@testable import ChatApp

class CreateChannelTest: XCTestCase {
    func testCreateChannel() throws {
        // Arrange
        let firebaseManager = FirebaseManagerMock()
        let coreDataStack = CoreDataStackMock()
        let channelService = ChannelsService(coreDataStack: coreDataStack, firebaseManager: firebaseManager)
        let channelName = "TestChannel"

        // Act
        channelService.createChannel(channelName)

        // Assert
        XCTAssertEqual(firebaseManager.createChannelCallCount, 1)
        XCTAssertEqual(firebaseManager.createChannelName, channelName)
    }
}
