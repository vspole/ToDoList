//
//  TestDependencyContainer.swift
//  UnderDogToDoListTests
//
//  Created by Vishal Polepalli on 11/15/22.
//

@testable import UnderDogToDoList
import XCTest

class TestDependencyContainer: XCTestCase {
    var container: DependencyContainer!
    
    override func setUpWithError() throws {
        container = DependencyContainer().createTestDependencyContainer()
    }
    
    override func tearDownWithError() throws {
        container = nil
    }
}

extension DependencyContainer {
    func createTestDependencyContainer() -> DependencyContainer {
        let container = DependencyContainer()
        
        container.components = [
            AlertService(container: container),
            DataComponent(container: container),
            MockFirebaseAuthService(container: container),
            MockFirestoreService(container: container),
            DataComponent(container: container),
            MockTokenManager(),
            AlertService(container: container),
            MockLocalStorageManager()
        ]
        
        return container
    }
}

// Extension of Mock Entities

extension DependencyContainer {
    var mockFirebaseAuthService: MockFirebaseAuthService { getComponent() }
    var mockFirestoreService: MockFirestoreService { getComponent() }
    var mockTokenManager: MockTokenManager { getComponent() }
    var mockLocalStorageManager: MockLocalStorageManager { getComponent() }
}
