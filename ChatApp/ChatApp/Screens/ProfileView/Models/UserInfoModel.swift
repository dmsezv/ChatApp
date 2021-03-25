//
//  UserInfoModel.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 18.03.2021.
//

import Foundation

struct UserInfoModel: Codable {
    var name: String?
    var position: String?
    var city: String?
    var avatarData: Data?
}
