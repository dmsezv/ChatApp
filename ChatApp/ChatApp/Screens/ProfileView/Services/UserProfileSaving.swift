//
//  UserProfileSaving.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 16.03.2021.
//

import Foundation


protocol UserProfileSaving {
    func fetch(_ info: Any)
    func save(_ info: Any)
}
