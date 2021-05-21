//
//  FirebaseManagerMock.swift
//  ChatAppTests
//
//  Created by Dmitrii Zverev on 04.05.2021.
//

@testable import ChatApp
import Firebase

class FirebaseManagerMock: FirebaseManagerProtocol {

    // MARK: - Public

    var documentChanges: [DocumentChange]?

    // MARK: - Private

    private(set) var channelName: String?
    private(set) var channelId: String?
    private(set) var messageDocumentId: String?
    private(set) var messageData: [String: Any]?

    // MARK: - Counters

    private(set) var listenChangesChannelListCallCount = 0
    private(set) var createChannelCallCount = 0
    private(set) var deleteChannelCallCount = 0
    private(set) var listenChangesMessageListCallCount = 0
    private(set) var addMessageCallCount = 0
    private(set) var removeListenerMessagesCallCount = 0

    func listenChangesChannelList(_ completeHandler: @escaping ([DocumentChange]?) -> Void) {
        listenChangesChannelListCallCount += 1
        completeHandler(documentChanges)
    }

    func createChannel(_ name: String) {
        channelName = name
        createChannelCallCount += 1
    }

    func deleteChannel(_ identifier: String) {
        channelId = identifier
        deleteChannelCallCount += 1
    }

    func listenChangesMessageList(in identifierChannel: String,
                                  _ completeHandler: @escaping ([DocumentChange]?) -> Void) {
        channelId = identifierChannel
        listenChangesMessageListCallCount += 1
        completeHandler(documentChanges)
    }

    func addMessage(data: [String: Any], to documentId: String) {
        messageData = data
        messageDocumentId = documentId
        addMessageCallCount += 1
    }

    func removeListenerMessages() {
        removeListenerMessagesCallCount += 1
    }
}
