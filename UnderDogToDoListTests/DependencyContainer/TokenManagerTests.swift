//
//  TokenManagerTests.swift
//  UnderDogToDoListTests
//
//  Created by Vishal Polepalli on 11/10/22.
//

@testable import UnderDogToDoList
import XCTest

class TokenManagerTests: TestDependencyContainer {
    var tokenManager: TokenManager!
    
    override func setUpWithError() throws {
        container = DependencyContainer().createTestDependencyContainer()
        tokenManager = TokenManager(container: container)
    }

    override func tearDownWithError() throws {
        tokenManager = nil
    }

    func test_storeToken_usesStorageManager() {
        // Act
        tokenManager.storeToken(token: "abc123")

        // Assert
        XCTAssertEqual(container.mockLocalStorageManager.securelyStoreCallCount, 1)
    }

    func test_retrieveToken_usesStorageManager() {
        // Act
        _ = tokenManager.retrieveToken()

        // Assert
        XCTAssertEqual(container.mockLocalStorageManager.securelyRetrieveDataCallCount, 1)
    }
}
