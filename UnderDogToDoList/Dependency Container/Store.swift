//
//  Store.swift
//  UnderDogToDoList
//
//  Created by Vishal Polepalli on 11/10/22.
//

//  Original source from Alexey Naumov, made available via MIT License
//  Clean Architecture for SwiftUI + Combine
//  https://github.com/nalexn/clean-architecture-swiftui

import Combine
import SwiftUI

/// Provides a generic CurrentValueSubject of an entity that never fails
typealias Store<State> = CurrentValueSubject<State, Never>

extension Store {

    subscript<T>(keyPath: WritableKeyPath<Output, T>) -> T where T: Equatable {
        get { value[keyPath: keyPath] }
        set {
            var value = self.value
            if value[keyPath: keyPath] != newValue {
                value[keyPath: keyPath] = newValue
                self.value = value
            }
        }
    }

    func bulkUpdate(_ update: (inout Output) -> Void) {
        var value = self.value
        update(&value)
        self.value = value
    }

    func publisher<Value>(for keyPath: KeyPath<Output, Value>) -> AnyPublisher<Value, Failure> where Value: Equatable {
        map(keyPath).removeDuplicates().eraseToAnyPublisher()
    }

    func binding<Value>(for keyPath: WritableKeyPath<Output, Value>) -> Binding<Value> {
        Binding(get: { self.value[keyPath: keyPath] }, set: { self.value[keyPath: keyPath] = $0 })
    }
}
