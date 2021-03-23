//
//  ChannelModel.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 24.03.2021.
//

import Foundation

struct ChannelModel {
    let identifier: String
    let name: String
    let lastMessage: String?
    let lastActivity: Date?
}
