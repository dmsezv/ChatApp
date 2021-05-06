//
//  FirebaseManagerMock.swift
//  ChatAppTests
//
//  Created by Dmitrii Zverev on 04.05.2021.
//

@testable import ChatApp
import Firebase

class FirebaseManagerMock: FirebaseManagerProtocol {
    var documentChanges: [DocumentChange]?
    var createChannelName: String?
    var deleteChannelIdentifier: String?
    var messageDocumentId: String?
    var addMessageData: [String: Any]?

    // Counters

    var listenChangesChannelListCallCount = 0
    var createChannelCallCount = 0
    var deleteChannelCallCount = 0
    var listenChangesMessageListCallCount = 0
    var addMessageCallCount = 0
    var removeListenerMessagesCallCount = 0

    func listenChangesChannelList(_ completeHandler: @escaping ([DocumentChange]?) -> Void) {
        listenChangesChannelListCallCount += 1
        completeHandler(documentChanges)
    }

    func createChannel(_ name: String) {
        createChannelName = name
        createChannelCallCount += 1
    }

    func deleteChannel(_ identifier: String) {
        deleteChannelIdentifier = identifier
        deleteChannelCallCount += 1
    }

    func listenChangesMessageList(in identifierChannel: String,
                                  _ completeHandler: @escaping ([DocumentChange]?) -> Void) {
        listenChangesMessageListCallCount += 1
        completeHandler(documentChanges)
    }

    func addMessage(data: [String: Any], to documentId: String) {
        addMessageData = data
        messageDocumentId = documentId
        addMessageCallCount += 1
    }

    func removeListenerMessages() {
        removeListenerMessagesCallCount += 1
    }
}
