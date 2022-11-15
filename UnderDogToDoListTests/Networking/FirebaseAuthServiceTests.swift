//
//  FirebaseAuthServiceTests.swift
//  UnderDogToDoListTests
//
//  Created by Vishal Polepalli on 11/10/22.
//

@testable import UnderDogToDoList
import XCTest
import FirebaseAuth

class FirebaseAuthServiceTests: XCTestCase {
    var dependencyContainer: DependencyContainer!
    var firebaseAuthService: MockFirebaseAuthService!
    
    override func setUpWithError() throws {
        dependencyContainer = DependencyContainer()
        firebaseAuthService = MockFirebaseAuthService(container: dependencyContainer)
        dependencyContainer.components = [
            firebaseAuthService,
        ]
    }
    
    override func tearDownWithError() throws {
        dependencyContainer = nil
        firebaseAuthService = nil
    }
    
    func test_requestOTP() {
        // Act
        firebaseAuthService.requestOTP(phoneNumber: "") { _,_  in }
        
        // Assert
        XCTAssertEqual(firebaseAuthService.requestOTPCallCount, 1)
    }
    
    func test_signInWithCode() {
        // Act
        firebaseAuthService.signInWithCode(code: "", verificationId: "") { _,_  in }
        
        // Assert
        XCTAssertEqual(firebaseAuthService.signInWithCodeCallCount, 1)
    }
    
    func test_getUserIDToken() {
        // Act
        firebaseAuthService.getUserIDToken() { _ in }
        
        // Assert
        XCTAssertEqual(firebaseAuthService.getUserIDTokenCallCount, 1)
    }
    
    func test_getCurrentUser() {
        // Act
        _ = firebaseAuthService.getCurrentUser()
        
        // Assert
        XCTAssertEqual(firebaseAuthService.getCurrentUserCallCount, 1)
    }
    
    func test_isUserSignedIn() {
        // Act
        _ = firebaseAuthService.isUserSignedIn()
        
        // Assert
        XCTAssertEqual(firebaseAuthService.isUserSignedInCallCount, 1)
    }
    
    func test_signOutUser() {
        // Act
        firebaseAuthService.signOutUser()
        
        // Assert
        XCTAssertEqual(firebaseAuthService.signOutUserCallCount, 1)
    }
}
