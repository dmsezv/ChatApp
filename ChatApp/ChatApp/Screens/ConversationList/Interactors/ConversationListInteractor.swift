//
//  ConversationListInteractor.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 22.03.2021.
//

import Foundation
import Firebase

protocol ConversationListBusinessLogic {
    func getChannelList()
}

class ConversationListInteractor: ConversationListBusinessLogic {
    weak var viewController: ConversationListDisplayLogic?
        
    lazy var db = Firestore.firestore()
    lazy var reference = db.collection("channels")
    
    
    func getChannelList() {
        reference.addSnapshotListener { [weak self] snapshot, error in
            
            print(snapshot!.documents[0].data())
        }
    }
}
