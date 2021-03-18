//
//  UserInformationSaverGCD.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 17.03.2021.
//

import UIKit


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
                        
            do {
                let data = try JSONEncoder().encode(model)
                
                do {
                    try data.write(to: docDirUrl.appendingPathComponent("profileInfo.json"))
                    
                    complete(.success(()))
                } catch {
                    complete(.failure(.savingError))
                }
            } catch {
                complete(.failure(.encodingError))
            }
        }
    }
    
    func fetchInfo(_ complete: @escaping (Result<UserInfoModel?, UserInfoSaverError>) -> Void) {
        DispatchQueue.global(qos: .utility).async {
            guard let docDirUrl: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                complete(.failure(.savingError))
                return
            }
                        
            do {
                let pathComponent = docDirUrl.appendingPathComponent("profileInfo.json")
                if !FileManager.default.fileExists(atPath: pathComponent.path) {
                    complete(.success(nil))
                }
                
                let data = try Data(contentsOf: pathComponent)
                
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
    
    func cancelSaving() {
        //TODO: cancel GCD (не успел)
        //DispatchWorkItem нужно было использовать
    }
}
