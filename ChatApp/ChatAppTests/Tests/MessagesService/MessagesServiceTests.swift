//
//  MessagesServiceTests.swift
//  ChatAppTests
//
//  Created by Dmitrii Zverev on 06.05.2021.
//

@testable import ChatApp
import XCTest
import Firebase

class MessagesServiceTests: XCTestCase {

    func testSendMessage() throws {
        // Arrange
        let firebaseManager = FirebaseManagerMock()
        let coreDataStack = CoreDataStackMock()
        let userInfoSaver = UserInfoSaverGCDMock()
        userInfoSaver.senderName = "Dmitrii Zverev"
        userInfoSaver.senderId = "test sender id"

        let messageService = MessagesService(coreDataStack: coreDataStack,
                                             firebaseManager: firebaseManager,
                                             userInfoDataManager: userInfoSaver)
        let message = "Test message"
        let documentId = "Test document id"

        // Act
        messageService.send(message, to: documentId)

        // Assert
        XCTAssertEqual(firebaseManager.messageDocumentId, documentId)
        XCTAssertEqual(firebaseManager.messageData?["content"] as? String, message)
        XCTAssertEqual(firebaseManager.messageData?["senderId"] as? String, userInfoSaver.senderId)
        XCTAssertEqual(firebaseManager.messageData?["senderName"] as? String, userInfoSaver.senderName)
        XCTAssertEqual(firebaseManager.addMessageCallCount, 1)
    }

    func testRemoveListenerMessages() throws {
        // Arrange
        let firebaseManager = FirebaseManagerMock()
        let coreDataStack = CoreDataStackMock()
        let userInfoSaver = UserInfoSaverGCDMock()
        let messageService = MessagesService(coreDataStack: coreDataStack,
                                             firebaseManager: firebaseManager,
                                             userInfoDataManager: userInfoSaver)

        // Act
        messageService.removeListenerMessages()

        // Assert
        XCTAssertEqual(firebaseManager.removeListenerMessagesCallCount, 1)
    }

    func testSubscribeMessagesUpdating() throws {
        // Arrange
        let firebaseManager = FirebaseManagerMock()
        firebaseManager.documentChanges = [DocumentChange]()
        let coreDataStack = CoreDataStackMock()
        let userInfoSaver = UserInfoSaverGCDMock()
        let messageService = MessagesService(coreDataStack: coreDataStack,
                                             firebaseManager: firebaseManager,
                                             userInfoDataManager: userInfoSaver)
        let channelId = "test channel id"
        let expectation = expectation(description: "subscribeMessagesUpdating")

        // Act
        messageService.subscribeMessagesUpdating(in: channelId) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)

        // Assert
        XCTAssertEqual(firebaseManager.channelId, channelId)
        XCTAssertEqual(firebaseManager.listenChangesMessageListCallCount, 1)
        XCTAssertEqual(coreDataStack.performSaveCallCount, 1)
    }
}
