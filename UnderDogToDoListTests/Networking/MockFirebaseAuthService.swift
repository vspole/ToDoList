//
//  MockFirebaseAuthService.swift
//  UnderDogToDoListTests
//
//  Created by Vishal Polepalli on 11/10/22.
//

@testable import UnderDogToDoList
import FirebaseAuth

class MockFirebaseAuthService: DependencyContainer.Component, FirebaseAuthServiceProtocol {
    
    private(set) var requestOTPCallCount = 0
    private(set) var signInWithCodeCallCount = 0
    private(set) var getUserIDTokenCallCount = 0
    private(set) var getCurrentUserCallCount = 0
    private(set) var isUserSignedInCallCount = 0
    private(set) var signOutUserCallCount = 0
        
    func requestOTP(phoneNumber: String, completion: @escaping (String?, Error?) -> Void) {
        requestOTPCallCount += 1
    }
    
    func signInWithCode(code: String, verificationId: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        signInWithCodeCallCount += 1
    }
    
    func getUserIDToken(completion: @escaping (String?) -> Void) {
        getUserIDTokenCallCount += 1
    }
    
    func getCurrentUser() -> User? {
        getCurrentUserCallCount += 1
        return nil
    }
    
    func isUserSignedIn() -> Bool {
        isUserSignedInCallCount += 1
        return false
    }
    
    func signOutUser() {
        signOutUserCallCount += 1
    }
}
