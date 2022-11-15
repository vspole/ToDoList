//
//  LocalStorageManagerTests.swift
//  UnderDogToDoListTests
//
//  Created by Vishal Polepalli on 11/10/22.
//

@testable import UnderDogToDoList
import XCTest

class LocalStorageManagerTests: TestDependencyContainer {
    private var localStorageManager: LocalStorageManager!

    override func setUp() {
        self.localStorageManager = LocalStorageManager()
    }

    override func tearDown() {
        self.localStorageManager = nil
        
        super.tearDown()
    }

    func testSecurelyStoreAndRetrieveData() {
        let dataToStoreSecurely = "I am data to store securely"
        let key = "key.secure.data"
        
        self.localStorageManager.securelyStore(key: key, data: dataToStoreSecurely)

        let receivedData = self.localStorageManager.securelyRetrieveData(key: key) ?? ""
            
        XCTAssertEqual(receivedData, dataToStoreSecurely)
    }
    
    func testInsecurelyStoreAndRetrieveBoolData() {
        let dataToStoreSecurely = true
        let key = "key.insecure.data"
        
        self.localStorageManager.insecurelyStore(data: dataToStoreSecurely, forKey: key)
        
        let insecurelyStoredData = self.localStorageManager.insecurelyRetrieveData(forType: Bool.self, withKey: key) ?? !dataToStoreSecurely
        
        XCTAssertEqual(insecurelyStoredData as! Bool, dataToStoreSecurely)
    }
}
