//
//  BaseRequest.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 22.04.2021.
//

import Foundation

enum NetworkManagerError: Error {
    case dataNil
    case incorrectUrl
}

protocol NetworkManagerProtocol {
    func getData(request: URLRequest, completionHandler: @escaping (Result<Data, Error>) -> Void)
    func createUrlRequest(scheme: NetworkManagerScheme, host: String, path: String, queryParams: [String: String]?) -> URLRequest?
}

class NetworkManager: NetworkManagerProtocol {
    let session = URLSession.shared
    
    func getData(request: URLRequest, completionHandler: @escaping (Result<Data, Error>) -> Void) {
        let task = session.dataTask(with: request) { data, _, error in
            if let error = error {
                completionHandler(.failure(error))
            }
            
            if let data = data {
                completionHandler(.success(data))
            } else {
                completionHandler(.failure(NetworkManagerError.dataNil))
            }
        }
        task.resume()
    }
    
    func createUrlRequest(scheme: NetworkManagerScheme, host: String, path: String, queryParams: [String: String]?) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme.rawValue
        urlComponents.host = host
        urlComponents.path = path
        
        if let queryParams = queryParams {
            urlComponents.setQueryItems(with: queryParams)
        }
        
        if let url = urlComponents.url {
            return URLRequest(url: url)
        } else {
            return nil
        }
    }
}
