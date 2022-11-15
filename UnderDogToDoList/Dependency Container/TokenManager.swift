//
//  TokenManager.swift
//  UnderDogToDoList
//
//  Created by Vishal Polepalli on 11/10/22.
//

import Foundation


public protocol TokenManagerProtocol {
    func storeToken(token: String)
    func retrieveToken() -> String
}

public let accessTokenKey = "user.access.token"

class TokenManager: DependencyContainer.Component, TokenManagerProtocol {
    
    public func storeToken(token: String) {
        container.localStorageManager.securelyStore(key: accessTokenKey, data: token)
    }

    public func retrieveToken() -> String {
        container.localStorageManager.securelyRetrieveData(key: accessTokenKey) ?? ""
    }
}
