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
        let userInfoService = UserInfoService(userInfoManager: userInfoSaver)
        let expect = expectation(description: "fetchInfo")

        // Act
        userInfoService.fetchInfo { _ in
            expect.fulfill()
        } fail: { _ in
            XCTFail("UserInfoService fetchInfo is fail")
        }
        waitForExpectations(timeout: 5, handler: nil)

        // Assert
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
        let expect = expectation(description: "saveInfo")

        // Act
        userInfoService.saveInfo(userInfoModel) {
            expect.fulfill()
        } fail: { _ in
            XCTFail("UserInfoService saveInfo is fail")
        }
        waitForExpectations(timeout: 5, handler: nil)

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
        let userInfoService = UserInfoService(userInfoManager: userInfoSaver)
        var fetchedSenderName: String?

        // Act
        fetchedSenderName = userInfoService.senderName

        // Assert
        XCTAssertNotNil(fetchedSenderName)
        XCTAssertEqual(userInfoSaver.fetchSenderNameCallCount, 1)
    }

    func testFetchSenderId() throws {
        // Arrange
        let userInfoSaver = UserInfoSaverGCDMock()
        let userInfoService = UserInfoService(userInfoManager: userInfoSaver)
        var fetchedSenderId: String?

        // Act
        fetchedSenderId = userInfoService.senderId

        // Assert
        XCTAssertNotNil(fetchedSenderId)
        XCTAssertEqual(userInfoSaver.fetchSenderIdCallCount, 1)
    }
}
