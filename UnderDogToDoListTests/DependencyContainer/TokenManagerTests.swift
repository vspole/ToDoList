//
//  TokenManagerTests.swift
//  UnderDogToDoListTests
//
//  Created by Vishal Polepalli on 11/10/22.
//

@testable import UnderDogToDoList
import XCTest

class TokenManagerTests: XCTestCase {
    var container: DependencyContainer!
    var sut: TokenManager!
    var storageManager: MockLocalStorageManager!
    var dataComponent: DataComponent!

    override func setUpWithError() throws {
        container = DependencyContainer()
        sut = TokenManager(container: container)
        dataComponent = DataComponent(container: container)
        storageManager = MockLocalStorageManager()
        container.components = [
            sut,
            storageManager,
            dataComponent
        ]
    }

    override func tearDownWithError() throws {
        container = nil
        sut = nil
        storageManager = nil
        dataComponent = nil
    }

    func test_storeToken_usesStorageManager() {
        // Act
        sut.storeToken(token: "abc123")

        // Assert
        XCTAssertEqual(storageManager.securelyStoreCallCount, 1)
    }

    func test_retrieveToken_usesStorageManager() {
        // Act
        _ = sut.retrieveToken()

        // Assert
        XCTAssertEqual(storageManager.securelyRetrieveDataCallCount, 1)
    }
}
