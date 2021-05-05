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
    
    func listenChangesChannelList(_ completeHandler: @escaping ([DocumentChange]?) -> Void) {
    }
    
    func createChannel(_ name: String) {
                
    }
    
    func deleteChannel(_ identifier: String) {
        
    }
    
    func listenChangesMessageList(in identifierChannel: String, _ completeHandler: @escaping ([DocumentChange]?) -> Void) {
    }
    
    func addMessage(data: [String : Any], to documentId: String) {
        
    }
    
    func removeListenerMessages() {
        
    }
    
}
