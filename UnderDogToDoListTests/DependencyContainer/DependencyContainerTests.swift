//
//  DependencyContainerTests.swift
//  UnderDogToDoListTests
//
//  Created by Vishal Polepalli on 11/10/22.
//

@testable import UnderDogToDoList
import XCTest

class DependencyContainerTests: XCTestCase {

    func test_startUp_componentsSortedByPriority() {
        // Arrange
        let sut = DependencyContainer()
        let order = MockOrderComponent(entity: sut)
        sut.components = [
            order,
            MockNormalPriorityComponent(entity: sut),
            MockLowPriorityComponent(entity: sut),
            MockHighPriorityComponent(entity: sut)
        ]
        
        // Act
        sut.startUp()
        
        // Assert
        XCTAssertEqual(order.ids.count, 3)
        XCTAssertEqual(order.ids[0], MockHighPriorityComponent.id)
        XCTAssertEqual(order.ids[1], MockNormalPriorityComponent.id)
        XCTAssertEqual(order.ids[2], MockLowPriorityComponent.id)
    }

}

private class MockOrderComponent: DependencyContainer.Component {
    var ids: [String] = []
}

private class MockLowPriorityComponent: DependencyContainer.Component, StartUpProtocol {
    static let id = UUID().uuidString
    
    var priority: StartUpPriority {
        .low
    }
    
    func startUp() {
        let component: MockOrderComponent = entity.getComponent()
        component.ids.append(Self.id)
    }
}

private class MockNormalPriorityComponent: DependencyContainer.Component, StartUpProtocol {
    static let id = UUID().uuidString
    
    // Intentionally did not specify priority to check the default provided by the StartUpProtocol
    
    func startUp() {
        let component: MockOrderComponent = entity.getComponent()
        component.ids.append(Self.id)
    }
}

private class MockHighPriorityComponent: DependencyContainer.Component, StartUpProtocol {
    static let id = UUID().uuidString
    
    var priority: StartUpPriority {
        .high
    }
    
    func startUp() {
        let component: MockOrderComponent = entity.getComponent()
        component.ids.append(Self.id)
    }
}
