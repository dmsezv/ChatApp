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

    private(set) var saveInfoCallCount = 0
    private(set) var fetchInfoCallCount = 0
    private(set) var cancelSavingCallCount = 0
    private(set) var fetchSenderIdCallCount = 0
    private(set) var fetchSenderNameCallCount = 0

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
        fetchSenderIdCallCount += 1
        return senderId ?? "incorrect sender id"
    }

    func fetchSenderName() -> String {
        fetchSenderNameCallCount += 1
        return senderName ?? "incorrect sender name"
    }
}