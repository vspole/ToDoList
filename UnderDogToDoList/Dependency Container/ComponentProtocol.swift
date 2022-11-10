//
//  ComponentProtocol.swift
//  UnderDogToDoList
//
//  Created by Vishal Polepalli on 11/10/22.
//

import Foundation

/// Part of the `Entity` `Component` architecture pattern.  Provides a reference to a container entity.
public protocol ComponentProtocol: AnyObject {
    associatedtype EntityType: EntityProtocol

    var entity: EntityType { get set }
}

public extension ComponentProtocol {
    func getEntityComponent<T>() -> T {
        guard let component: T = entity.getComponent() else { fatalError("Unable to obtain reference to entity component of type '\(T.self)'") }
        return component
    }
}
