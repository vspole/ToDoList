//
//  MockLocalStorageManager.swift
//  UnderDogToDoListTests
//
//  Created by Vishal Polepalli on 11/10/22.
//

@testable import UnderDogToDoList

public class MockLocalStorageManager: LocalStorageManagerProtocol {
    public private(set) var securelyStoreCallCount = 0
    public private(set) var securelyRetrieveDataCallCount = 0
    public private(set) var insecurelyStoreDataCallCount = 0
    public private(set) var insecurelyRetrieveDataCallCount = 0
    public private(set) var insecurelyStoreEncodableCallCount = 0
    public private(set) var insecurelyRetrieveDecodableCallCount = 0
    
    public var fakeDataString: String?
    public var fakeData: Any?
    public var fakeStore: [String: Any] = [:]
    
    public init() {
        // No-op
    }
    
    public func securelyStore(key: String, data: String) {
        securelyStoreCallCount += 1
    }
    
    public func securelyRetrieveData(key: String) -> String? {
        securelyRetrieveDataCallCount += 1
        return fakeDataString
    }
    
    public func insecurelyStore(data: Any, forKey: String) {
        insecurelyStoreDataCallCount += 1
    }
    
    public func insecurelyRetrieveData<T>(forType: T.Type, withKey: String) -> Any? {
        insecurelyRetrieveDataCallCount += 1
        return fakeData
    }
    
    public func insecurelyStore<T: Encodable>(encodable: T, forKey: String) throws {
        insecurelyStoreEncodableCallCount += 1
        fakeStore[forKey] = encodable
    }
    
    public func insecurelyRetrieve<T: Decodable>(withKey: String) throws -> T? {
        insecurelyRetrieveDecodableCallCount += 1
        return fakeStore[withKey] as? T
    }
}
