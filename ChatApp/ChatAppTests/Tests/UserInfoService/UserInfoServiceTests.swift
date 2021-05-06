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
            XCTFail("UserInfoService fetch model is fail")
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
}
