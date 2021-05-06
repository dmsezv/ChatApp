//
//  AvatarNetworkModel.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 22.04.2021.
//

import Foundation

enum AvatarNetworkModel {
    struct Request {
        var indexImage: Int
    }
    struct Response {
        var urls: [URL]?
        var isError: Bool
    }
    struct ViewModel {
        var countImages: Int
    }
}
