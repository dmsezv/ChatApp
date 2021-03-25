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

protocol UserInfoSaver {
    func saveInfo(_ model: UserInfoModel, complete: @escaping (Result<Void, UserInfoSaverError>) -> Void)
    func fetchInfo(_ complete: @escaping (Result<UserInfoModel?, UserInfoSaverError>) -> Void)
    func cancelSaving()
}
