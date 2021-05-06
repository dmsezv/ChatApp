//
//  UserInfoServiceTests.swift
//  ChatAppTests
//
//  Created by Dmitrii Zverev on 06.05.2021.
//

@testable import ChatApp
import XCTest

class UserInfoServiceTests: XCTestCase {

    func testFetchInfo() throws {
        // Arrange
        let userInfoSaver = UserInfoSaverGCDMock()
        let userInfoModel: UserInfoModel = UserInfoModel(
            name: "Dmitrii Zverev",
            position: "iOS Dev",
            city: "Moscow")
        userInfoSaver.userInfoModel = userInfoModel
        let userInfoService = UserInfoService(userInfoManager: userInfoSaver)
        var userModelResult: UserInfoModel?
        let expectation = expectation(description: "fetchInfo")

        // Act
        userInfoService.fetchInfo { userInfoModel in
            userModelResult = userInfoModel
            expectation.fulfill()
        } fail: { _ in
            XCTFail("UserInfoService fetchInfo is fail")
        }

        waitForExpectations(timeout: 5, handler: nil)

        // Assert
        XCTAssertNotNil(userModelResult)
        XCTAssertEqual(userInfoModel.name, userModelResult?.name)
        XCTAssertEqual(userInfoModel.position, userModelResult?.position)
        XCTAssertEqual(userInfoModel.city, userModelResult?.city)
        XCTAssertEqual(userInfoModel.avatarData, userModelResult?.avatarData)
        XCTAssertEqual(userInfoSaver.fetchInfoCallCount, 1)
    }

    func testSaveInfo() throws {
        // Arrange
        let userInfoSaver = UserInfoSaverGCDMock()
        let userInfoModel: UserInfoModel = UserInfoModel(
            name: "Dmitrii Zverev",
            position: "iOS Dev",
            city: "Moscow")
        let userInfoService = UserInfoService(userInfoManager: userInfoSaver)

        // Act
        userInfoService.saveInfo(userInfoModel) {}
            fail: { _ in
                XCTFail("UserInfoService saveInfo is fail")
            }

        // Assert
        XCTAssertNotNil(userInfoSaver.userInfoModel)
        XCTAssertEqual(userInfoSaver.userInfoModel?.name, userInfoModel.name)
        XCTAssertEqual(userInfoSaver.userInfoModel?.position, userInfoModel.position)
        XCTAssertEqual(userInfoSaver.userInfoModel?.city, userInfoModel.city)
        XCTAssertEqual(userInfoSaver.userInfoModel?.avatarData, userInfoModel.avatarData)
        XCTAssertEqual(userInfoSaver.saveInfoCallCount, 1)
    }

    func testFetchSenderName() throws {
        // Arrange
        let userInfoSaver = UserInfoSaverGCDMock()
        userInfoSaver.senderName = "Dmitrii Zverev"
        let userInfoService = UserInfoService(userInfoManager: userInfoSaver)
        var fetchedSenderName: String?

        // Act
        fetchedSenderName = userInfoService.senderName

        // Assert
        XCTAssertNotNil(fetchedSenderName)
        XCTAssertEqual(userInfoSaver.senderName, fetchedSenderName)
        XCTAssertEqual(userInfoSaver.fetchSenderNameCallCount, 1)
    }

    func testFetchSenderId() throws {
        // Arrange
        let userInfoSaver = UserInfoSaverGCDMock()
        userInfoSaver.senderId = "test sender id"
        let userInfoService = UserInfoService(userInfoManager: userInfoSaver)
        var fetchedSenderId: String?

        // Act
        fetchedSenderId = userInfoService.senderId

        // Assert
        XCTAssertNotNil(fetchedSenderId)
        XCTAssertEqual(userInfoSaver.senderId, fetchedSenderId)
        XCTAssertEqual(userInfoSaver.fetchSenderIdCallCount, 1)
    }
}
