//
//  ScrabbleGameTests.swift
//  ScrabbleGameTests
//
//  Created by Юлия Гудошникова on 17.06.2024.
//

import XCTest
@testable import ScrabbleGame

class UserTests: XCTestCase {
    var userStorage: UserDefaultsService!
    let userId = UUID()

    override func setUp() {
        super.setUp()
        userStorage = UserDefaultsService.shared
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
    }

    override func tearDown() {
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
        super.tearDown()
    }

    func testSetCurrentUser() {
        userStorage.setCurrentUser(id: userId.uuidString, nickName: "JohnDoe", token: "token123")
        XCTAssertEqual(UserDefaults.standard.string(forKey: "currentUserId"), userId.uuidString)
        XCTAssertEqual(UserDefaults.standard.string(forKey: "currentUserNickName"), "JohnDoe")
        XCTAssertEqual(UserDefaults.standard.string(forKey: "currentUserToken"), "token123")
    }

    func testGetCurrentUser() {
        UserDefaults.standard.set(userId.uuidString, forKey: "currentUserId")
        UserDefaults.standard.set("JohnDoe", forKey: "currentUserNickName")
        UserDefaults.standard.set("token123", forKey: "currentUserToken")
        let user = userStorage.getCurrentUser()
        XCTAssertEqual(user.id.uuidString, userId.uuidString)
        XCTAssertEqual(user.nickName, "JohnDoe")
        XCTAssertEqual(user.token, "token123")
    }

    func testClearCurrentUser() {
        UserDefaults.standard.set(userId.uuidString, forKey: "currentUserId")
        UserDefaults.standard.set("JohnDoe", forKey: "currentUserNickName")
        UserDefaults.standard.set("token123", forKey: "currentUserToken")
        userStorage.clearCurrentUser()
        XCTAssertNil(UserDefaults.standard.string(forKey: "currentUserId"))
        XCTAssertNil(UserDefaults.standard.string(forKey: "currentUserNickName"))
        XCTAssertNil(UserDefaults.standard.string(forKey: "currentUserToken"))
        XCTAssertNil(userStorage.currentUser)
    }
}
