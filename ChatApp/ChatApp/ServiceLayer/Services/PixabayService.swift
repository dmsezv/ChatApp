//
//  PixabayService.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 22.04.2021.
//

import Foundation

protocol PixabayServiceProtocol {
    func getImagesUrls(complete: @escaping(_ urls: [URL]) -> Void)
    func getImageData(by url: URL, complete: @escaping(_ image: Data) -> Void)
}

struct PixabayApiModel: Codable {
    let totalHits: Int
    let hits: [HitsApiModel]?
    
    struct HitsApiModel: Codable {
        let id: Int
        let previewURL: String
        let largeImageURL: String
    }
}

class PixabayService: PixabayServiceProtocol {
    private let baseUrl = "https://pixabay.com/api/"
    private let query = "?key=21279061-d8b881ee813547d979885fff1&q=image_type"
    private let apiKey = "21279061-d8b881ee813547d979885fff1"
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func getImageData(by url: URL, complete: @escaping (Data) -> Void) {
        let request = URLRequest(url: url)
        networkManager.getData(request: request) { result in
            switch result {
            case .success(let data):
                complete(data)
            case .failure:
                break
            }
        }
    }
    
    func getImagesUrls(complete: @escaping ([URL]) -> Void) {
        let request = URLRequest(url: makeURL()!)
        networkManager.getData(request: request) { result in
            switch result {
            case .success(let data):
                let model = try? JSONDecoder().decode(PixabayApiModel.self, from: data)
                if let model = model {
                    complete(model.hits!.compactMap { URL(string: $0.previewURL)! })
                }
            case .failure:
                break
            }
        }
    }
    
    private func makeURL() -> URL? {
            guard var components = URLComponents(string: baseUrl) else { return nil }
            let keyQueryItems = URLQueryItem(name: "key", value: "21279061-d8b881ee813547d979885fff1")
            let descriptionQueryItem = URLQueryItem(name: "q", value: "animals")
            let prettyQueryItem = URLQueryItem(name: "pretty", value: "true")
            let batchSizeQueryItem = URLQueryItem(name: "per_page", value: "200")
            components.queryItems = [keyQueryItems, descriptionQueryItem, prettyQueryItem, batchSizeQueryItem]
            return components.url
        }
}
