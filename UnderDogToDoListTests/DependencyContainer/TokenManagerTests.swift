//
//  TokenManagerTests.swift
//  UnderDogToDoListTests
//
//  Created by Vishal Polepalli on 11/10/22.
//

@testable import UnderDogToDoList
import XCTest

class TokenManagerTests: XCTestCase {
    var entity: MockEntity!
    var sut: TokenManager<MockEntity>!
    var storageManager: MockLocalStorageManager!

    override func setUpWithError() throws {
        entity = MockEntity()
        sut = TokenManager(entity: entity)
        storageManager = MockLocalStorageManager()
        entity.components = [
            sut,
            storageManager
        ]
    }

    override func tearDownWithError() throws {
        entity = nil
        sut = nil
        storageManager = nil
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
