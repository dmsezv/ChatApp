//
//  UserInformationSaverGCD.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 17.03.2021.
//

import UIKit


enum UserInfoSaverError: Error {
    case parseFile
    case savingError
    case encodingError
    case decodingError
}

struct UserInfoModel: Codable {
    var name: String?
    var position: String?
    var city: String?
    var avatarData: Data?
}

class UserInfoSaverGCD: UserInfoSaver {
    static var docDir: URL? {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }

    
    func saveInfo(_ model: UserInfoModel, complete: @escaping (Result<Void, UserInfoSaverError>) -> Void) {
        DispatchQueue.global(qos: .utility).async {
            guard let docDirUrl: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                complete(.failure(.savingError))
                return
            }
            
            sleep(3)
            
            do {
                let data = try JSONEncoder().encode(model)
                
                do {
                    try data.write(to: docDirUrl.appendingPathComponent("test.json"))
                    
                    complete(.success(()))
                } catch {
                    complete(.failure(.savingError))
                }
            } catch {
                complete(.failure(.encodingError))
            }
        }
    }
    
    func fetchInfo(_ complete: @escaping (Result<UserInfoModel, UserInfoSaverError>) -> Void) {
        DispatchQueue.global(qos: .utility).async {
            guard let docDirUrl: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                complete(.failure(.savingError))
                return
            }
            
            sleep(3)
            
            do {
                let data = try Data(contentsOf: docDirUrl.appendingPathComponent("test.json"))
                
                do {
                    let userInfo = try JSONDecoder().decode(UserInfoModel.self, from: data)
                    
                    complete(.success(userInfo))
                } catch {
                    complete(.failure(.decodingError))
                }
            } catch {
                complete(.failure(.parseFile))
            }
        }
    }
}
