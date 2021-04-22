//
//  BaseRequest.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 22.04.2021.
//

import Foundation

enum NetworkManagerError: Error {
    case dataNil
}

protocol NetworkManagerProtocol {
    func getData(request: URLRequest, completionHandler: @escaping (Result<Data, Error>) -> Void)
}

class NetworkManager: NetworkManagerProtocol {
    let session = URLSession.shared
    
    func getData(request: URLRequest, completionHandler: @escaping (Result<Data, Error>) -> Void) {
        let task = session.dataTask(with: request) { data, response, error in
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
}
