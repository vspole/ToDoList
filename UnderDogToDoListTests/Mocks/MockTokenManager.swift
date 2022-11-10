//
//  MockTokenManager.swift
//  UnderDogToDoListTests
//
//  Created by Vishal Polepalli on 11/10/22.
//

@testable import UnderDogToDoList

public class MockTokenManager: TokenManagerProtocol {
    public private(set) var decodeTokenCallCount = 0
    public private(set) var storeTokenCallCount = 0
    public private(set) var retrieveTokenCallCount = 0
    public var fakeToken: String

    
    public init(fakeToken: String = "") {
        self.fakeToken = fakeToken
    }
    
    public func storeToken(token: String) {
        storeTokenCallCount += 1
        fakeToken = token
    }
    
    public func retrieveToken() -> String {
        retrieveTokenCallCount += 1
        return fakeToken
    }
}
