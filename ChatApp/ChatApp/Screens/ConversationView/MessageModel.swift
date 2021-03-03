//
//  MessageModel.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 03.03.2021.
//

import Foundation

protocol MessageCellConfiguration {
    var text: String { get set }
    var isIncoming: Bool { get set }
}


class MessageModel: MessageCellConfiguration {
    var text: String
    var isIncoming: Bool
    
    init(text: String, isIncoming: Bool) {
        self.text = text
        self.isIncoming = isIncoming
    }
    
    static func mockMessages() -> [MessageModel] {
        return [
            .init(text: "An suas viderer pro. Vis cu magna altera, ex his vivendo atomorum",
                  isIncoming: true),
            .init(text: "Reprehenderit mollit excepteur labore deserunt officia laboris eiusmod cillum eu duis",
                  isIncoming: true),
            .init(text: "Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem.",
                  isIncoming: false),
            .init(text: "Sed consequat",
                  isIncoming: true),
            .init(text: "Maecenas",
                  isIncoming: false),
            .init(text: "Integer tincidunt. Cras dapibus.",
                  isIncoming: false),
            .init(text: "Penatibus et magnis dis parturient montes, nascetur ridiculus mus",
                  isIncoming: true),
            .init(text: "Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec.",
                  isIncoming: true),
            .init(text: "Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac",
                  isIncoming: true),
            .init(text: "An suas viderer pro. Vis cu magna altera, ex his vivendo atomorum",
                  isIncoming: true),
            .init(text: "Reprehenderit mollit excepteur labore deserunt officia laboris eiusmod cillum eu duis",
                  isIncoming: true),
            .init(text: "Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem.",
                  isIncoming: false),
            .init(text: "Sed consequat",
                  isIncoming: true),
            .init(text: "Maecenas",
                  isIncoming: false),
            .init(text: "Integer tincidunt. Cras dapibus.",
                  isIncoming: false),
            .init(text: "Penatibus et magnis dis parturient montes, nascetur ridiculus mus",
                  isIncoming: true),
            .init(text: "Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec.",
                  isIncoming: true),
            .init(text: "Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac",
                  isIncoming: true),
            .init(text: "Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id.",
                  isIncoming: false),
            .init(text: "Donec sodales sagittis magna. Sed consequat, leo eget bibendum sodales, augue velit cursus nunc",
                  isIncoming: true),
            .init(text: "Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum.",
                  isIncoming: false),
            .init(text: "Cras dapibus.",
                  isIncoming: false),
            .init(text: "Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus.",
                  isIncoming: true)
        ]
    }
    
    enum MessageType {
        case icoming, outgoing
    }
}
