//
//  MockEntity.swift
//  UnderDogToDoListTests
//
//  Created by Vishal Polepalli on 11/10/22.
//

@testable import UnderDogToDoList

public class MockContainer: EntityProtocol {
    public var components: [AnyObject] = []
    
    public init() {
        // No-op
    }
}
