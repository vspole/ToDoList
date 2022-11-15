//
//  FirebaseAuthServiceTests.swift
//  UnderDogToDoListTests
//
//  Created by Vishal Polepalli on 11/10/22.
//

@testable import UnderDogToDoList
import XCTest
import FirebaseAuth

class FirebaseAuthServiceTests: TestDependencyContainer {
    
    func test_requestOTP() {
        // Act
        container.mockFirebaseAuthService.requestOTP(phoneNumber: "") { _,_  in }
        
        // Assert
        XCTAssertEqual(container.mockFirebaseAuthService.requestOTPCallCount, 1)
    }
    
    func test_signInWithCode() {
        // Act
        container.mockFirebaseAuthService.signInWithCode(code: "", verificationId: "") { _,_  in }
        
        // Assert
        XCTAssertEqual(container.mockFirebaseAuthService.signInWithCodeCallCount, 1)
    }
    
    func test_getUserIDToken() {
        // Act
        container.mockFirebaseAuthService.getUserIDToken() { _ in }
        
        // Assert
        XCTAssertEqual(container.mockFirebaseAuthService.getUserIDTokenCallCount, 1)
    }
    
    func test_getCurrentUser() {
        // Act
        _ = container.mockFirebaseAuthService.getCurrentUser()
        
        // Assert
        XCTAssertEqual(container.mockFirebaseAuthService.getCurrentUserCallCount, 1)
    }
    
    func test_isUserSignedIn() {
        // Act
        _ = container.mockFirebaseAuthService.isUserSignedIn()
        
        // Assert
        XCTAssertEqual(container.mockFirebaseAuthService.isUserSignedInCallCount, 1)
    }
    
    func test_signOutUser() {
        // Act
        container.mockFirebaseAuthService.signOutUser()
        
        // Assert
        XCTAssertEqual(container.mockFirebaseAuthService.signOutUserCallCount, 1)
    }
}
