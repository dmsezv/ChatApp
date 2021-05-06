//
//  Extension+URLComponents.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 22.04.2021.
//

import Foundation

extension URLComponents {
    mutating func setQueryItems(with parameters: [String: String]) {
        self.queryItems = parameters.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
    }
}
