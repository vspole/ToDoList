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
        unowned var container: DependencyContainer

        init(container: DependencyContainer) {
            self.container = container
        }
    }

    static func create() -> DependencyContainer {
        let container = DependencyContainer()
        container.components = [
            FirebaseAuthService(container: container),
            FirestoreService(container: container),
            DataComponent(container: container),
            TokenManager(container: container),
            AlertService(container: container),
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
    var alertService: AlertServiceProtocol { getComponent() }
}
