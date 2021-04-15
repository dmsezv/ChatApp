//
//  UserInfoSavable.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 17.03.2021.
//

import Foundation

enum UserInfoSaverError: Error {
    case savingError
    case encodingError
    case decodingError
    case noFile
}

enum UserInfoSaverType {
    case operation, gcd
}

protocol UserInfoManagerProtocol {
    func saveInfo(_ model: UserInfoModel, complete: @escaping (Result<Void, UserInfoSaverError>) -> Void)
    func fetchInfo(_ complete: @escaping (Result<UserInfoModel?, UserInfoSaverError>) -> Void)
    func cancelSaving()
    func fetchSenderId() -> String
    func fetchSenderName() -> String
}

extension UserInfoManagerProtocol {
    func fetchSenderId() -> String {
        if let senderId = UserDefaults.standard.string(forKey: "senderId") {
            return senderId
        } else {
            let senderId = UUID().uuidString
            UserDefaults.standard.set(senderId, forKey: "senderId")
            return senderId
        }
    }
    
    func fetchSenderName() -> String {
        if let senderName = UserDefaults.standard.string(forKey: "senderName"), !senderName.isEmpty {
            return senderName
        } else {
            let senderName = "Unknown"
            UserDefaults.standard.set(senderName, forKey: "senderName")
            return senderName
        }
    }
}
