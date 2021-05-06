//
//  PixabayApiModel.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 23.04.2021.
//

import Foundation

struct PixabayApiModel: Codable {
    let hits: [HitsApiModel]?
    
    struct HitsApiModel: Codable {
        let id: Int
        let previewURL: String
        let largeImageURL: String
    }
}
