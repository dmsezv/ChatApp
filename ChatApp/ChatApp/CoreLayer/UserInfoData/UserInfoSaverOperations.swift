//
//  UserInfoSaverOperations.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 17.03.2021.
//

import UIKit

class UserInfoSaverOperation: UserInfoManagerProtocol {
    private lazy var operationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .utility
        return queue
    }()
        
    func saveInfo(_ model: UserInfoModel, complete: @escaping (Result<Void, UserInfoSaverError>) -> Void) {
        let operation = SaveInfoOperation(model: model, completeHandler: complete)
        operationQueue.addOperation(operation)
    }
    
    func fetchInfo(_ complete: @escaping (Result<UserInfoModel?, UserInfoSaverError>) -> Void) {
        let operation = FetchInfoOperation(completeHandler: complete)
        operationQueue.addOperation(operation)
    }
    
    func cancelSaving() {
        operationQueue.cancelAllOperations()
    }
}

private class FetchInfoOperation: Operation {
    private var complete: (Result<UserInfoModel?, UserInfoSaverError>) -> Void
    
    init(completeHandler: @escaping(Result<UserInfoModel?, UserInfoSaverError>) -> Void) {
        self.complete = completeHandler
    }
    
    override func main() {
        if isCancelled { return }
        
        // TODO: дублирование кода надо вынести
        guard let docDirUrl: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            complete(.failure(.savingError))
            return
        }
        
        if isCancelled { return }
        guard let data = try? Data(contentsOf: docDirUrl.appendingPathComponent("profileInfo.json")) else {
            complete(.success(nil))
            return
        }
        
        do {
            if isCancelled { return }
            let userInfo = try JSONDecoder().decode(UserInfoModel.self, from: data)
            
            if isCancelled { return }
            complete(.success(userInfo))
        } catch {
            if isCancelled { return }
            complete(.failure(.decodingError))
            
        }
    }
}

private class SaveInfoOperation: Operation {
    private var model: UserInfoModel
    private var complete: (Result<Void, UserInfoSaverError>) -> Void
    
    init(model: UserInfoModel, completeHandler: @escaping(Result<Void, UserInfoSaverError>) -> Void) {
        self.model = model
        self.complete = completeHandler
    }
    
    override func main() {
        if isCancelled { return }
        
        // TODO: дублирование кода надо вынести
        guard let docDirUrl: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            if isCancelled { return }
            complete(.failure(.savingError))
            return
        }
                
        do {
            if isCancelled { return }
            let data = try JSONEncoder().encode(model)
                        
            do {
                if isCancelled { return }
                try data.write(to: docDirUrl.appendingPathComponent("profileInfo.json"))
                
                if isCancelled { return }
                complete(.success(()))
            } catch {
                if isCancelled { return }
                complete(.failure(.savingError))
            }
        } catch {
            if isCancelled { return }
            complete(.failure(.encodingError))
        }
    }
}
