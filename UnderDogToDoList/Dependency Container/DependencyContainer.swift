//
//  DependencyContainer.swift
//  UnderDogToDoList
//
//  Created by Vishal Polepalli on 11/10/22.
//

import Foundation

class DependencyContainer: ObservableObject, EntityProtocol {
    var components: [AnyObject] = []

}

extension DependencyContainer {
    class Component {
        unowned var entity: DependencyContainer

        init(entity: DependencyContainer) {
            self.entity = entity
        }
    }

    static func create() -> DependencyContainer {
        let container = DependencyContainer()
        container.components = [
            FirebaseAuthService(entity: container),
            FirestoreService(entity: container),
            DataComponent(entity: container),
            TokenManager(entity: container),
            LocalStorageManager()
        ]
        return container
    }
}

// MARK: - Convenience property wrappers

extension DependencyContainer {
    var firebaseAuthService: FirebaseAuthServiceProtocol { getComponent() }
    var firestoreService: FirestoreServiceProtocol { getComponent() }
    var localStorageManager: LocalStorageManagerProtocol { getComponent() }
    var appState: Store<AppState> { dataComponent.appState }
    var dataComponent: DataComponentProtocol { getComponent() }
    var tokenManager: TokenManagerProtocol { getComponent() }
}
