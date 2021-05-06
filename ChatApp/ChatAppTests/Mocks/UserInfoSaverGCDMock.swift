//
//  UserInfoSaverGCDMock.swift
//  ChatAppTests
//
//  Created by Dmitrii Zverev on 06.05.2021.
//

@testable import ChatApp
import Foundation

class UserInfoSaverGCDMock: UserInfoManagerProtocol {
    var userInfoModel: UserInfoModel?
    var testData: Data?
    var userInfoSaverError: UserInfoSaverError?
    var senderId: String?
    var senderName: String?

    // Counters

    var saveInfoCallCount = 0
    var fetchInfoCallCount = 0
    var cancelSavingCallCount = 0

    func saveInfo(_ model: UserInfoModel, complete: @escaping (Result<Void, UserInfoSaverError>) -> Void) {
        userInfoModel = model
        saveInfoCallCount += 1

        do {
            testData = try JSONEncoder().encode(model)
        } catch {
            userInfoSaverError = .decodingError
            complete(.failure(.decodingError))
        }

        complete(.success(()))
    }

    func fetchInfo(_ complete: @escaping (Result<UserInfoModel?, UserInfoSaverError>) -> Void) {
        fetchInfoCallCount += 1
        complete(.success(userInfoModel))
    }

    func cancelSaving() {
        cancelSavingCallCount += 1
    }

    func fetchSenderId() -> String {
        return senderId ?? "incorrect sender id"
    }

    func fetchSenderName() -> String {
        return senderName ?? "incorrect sender name"
    }
}
