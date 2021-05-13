//
//  PixabayService.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 22.04.2021.
//

import Foundation

protocol PixabayServiceProtocol {
    func getImagesUrls(complete: @escaping(_ urls: PixabayApiModel?) -> Void)
    func getImageData(by url: URL, complete: @escaping(_ image: Data?) -> Void)
}

// TODO: Не успеваю описать нормально сервис с хорошими колбеками, еррорами итд
class PixabayService: PixabayServiceProtocol {
    private let host = Bundle.main.infoDictionary?["PIXABAY_HOST"] as? String
    private let path = Bundle.main.infoDictionary?["PIXABAY_PATH_API"] as? String
    private let apiKey = Bundle.main.infoDictionary?["PIXABAY_API_KEY"] as? String
    
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func getImageData(by url: URL, complete: @escaping (Data?) -> Void) {
        networkManager.getData(request: URLRequest(url: url)) { result in
            switch result {
            case .success(let data):
                complete(data)
            case .failure:
                complete(nil)
            }
        }
    }
    
    func getImagesUrls(complete: @escaping (PixabayApiModel?) -> Void) {
        guard let host = host,
              let path = path,
              let apiKey = apiKey else {
            complete(nil)
            return
        }

        let queryParams: [String: String] = [
            "key": apiKey,
            "q": "animals",
            "pretty": "true",
            "per_page": "200"
        ]
        
        guard let request = networkManager.createUrlRequest(
                scheme: .HTTPS,
                host: host,
                path: path,
                queryParams: queryParams)
        else {
            complete(nil)
            return
        }
        
        networkManager.getData(request: request) { result in
            switch result {
            case .success(let data):
                let model = try? JSONDecoder().decode(PixabayApiModel.self, from: data)
                complete(model)
            case .failure:
                complete(nil)
            }
        }
    }
}
