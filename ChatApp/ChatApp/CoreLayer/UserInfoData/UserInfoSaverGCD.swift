//
//  UserInformationSaverGCD.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 17.03.2021.
//

import UIKit

class UserInfoSaverGCD: UserInfoManagerProtocol {
    
    private lazy var dispatchQueue = DispatchQueue.global()
    private var dispatchWorkItem: DispatchWorkItem?
    
    func saveInfo(_ model: UserInfoModel, complete: @escaping (Result<Void, UserInfoSaverError>) -> Void) {
        dispatchWorkItem = DispatchWorkItem { [weak self] in
            
            if self?.dispatchWorkItem?.isCancelled ?? true { return }
            
            // TODO: дублирование кода надо вынести
            guard let docDirUrl: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                if self?.dispatchWorkItem?.isCancelled ?? true { return }
                complete(.failure(.savingError))
                return
            }
                    
            do {
                if self?.dispatchWorkItem?.isCancelled ?? true { return }
                let data = try JSONEncoder().encode(model)
                                
                do {
                    if self?.dispatchWorkItem?.isCancelled ?? true { return }
                    try data.write(to: docDirUrl.appendingPathComponent("profileInfo.json"))
                    UserDefaults.standard.set(model.name, forKey: "senderName")
                    if self?.dispatchWorkItem?.isCancelled ?? true { return }
                    complete(.success(()))
                } catch {
                    if self?.dispatchWorkItem?.isCancelled ?? true { return }
                    complete(.failure(.savingError))
                }
            } catch {
                if self?.dispatchWorkItem?.isCancelled ?? true { return }
                complete(.failure(.encodingError))
            }
        }
        
        if let dispatchWorkItem = dispatchWorkItem {
            dispatchQueue.async(execute: dispatchWorkItem)
        }
    }
    
    func fetchInfo(_ complete: @escaping (Result<UserInfoModel?, UserInfoSaverError>) -> Void) {
        dispatchWorkItem = DispatchWorkItem { [weak self] in
            
            // TODO: дублирование кода надо вынести
            guard let docDirUrl: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                complete(.failure(.savingError))
                return
            }
            
            if self?.dispatchWorkItem?.isCancelled ?? true { return }
            guard let data = try? Data(contentsOf: docDirUrl.appendingPathComponent("profileInfo.json")) else {
                complete(.success(nil))
                return
            }
                        
            do {
                if self?.dispatchWorkItem?.isCancelled ?? true { return }
                let userInfo = try JSONDecoder().decode(UserInfoModel.self, from: data)
                
                if self?.dispatchWorkItem?.isCancelled ?? true { return }
                complete(.success(userInfo))
            } catch {
                if self?.dispatchWorkItem?.isCancelled ?? true { return }
                complete(.failure(.decodingError))
                
            }
            
        }
        
        if let dispatchWorkItem = dispatchWorkItem {
            dispatchQueue.async(execute: dispatchWorkItem)
        }
    }
    
    func cancelSaving() {
        dispatchQueue.async {
            self.dispatchWorkItem?.cancel()
            self.dispatchWorkItem = nil
        }
    }
}
