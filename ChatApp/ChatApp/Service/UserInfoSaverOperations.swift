//
//  UserInfoSaverOperations.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 17.03.2021.
//

import UIKit


class UserInfoSaverOperation: UserInfoSaver {
    lazy var operationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .utility
        return queue
    }()
    
    func saveInfo(_ model: UserInfoModel, complete: @escaping (Result<Void, UserInfoSaverError>) -> Void) {
        operationQueue.addOperation {
            guard let docDirUrl: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                complete(.failure(.savingError))
                return
            }
            
            sleep(3)
            
            do {
                let data = try JSONEncoder().encode(model)
                
                do {
                    try data.write(to: docDirUrl.appendingPathComponent("test.json"))
                    
                    complete(.success(()))
                } catch {
                    complete(.failure(.savingError))
                }
            } catch {
                complete(.failure(.encodingError))
            }
        }
    }
    
    func fetchInfo(_ complete: @escaping (Result<UserInfoModel, UserInfoSaverError>) -> Void) {
        
    }
}
