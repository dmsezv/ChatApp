//
//  UserInfoSavable.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 17.03.2021.
//

import Foundation

protocol UserInfoSaver {
    func saveInfo(_ model: UserInfoModel, complete: @escaping (Result<Void, UserInfoSaverError>) -> Void)
    func fetchInfo(_ complete: @escaping (Result<UserInfoModel, UserInfoSaverError>) -> Void)
}
