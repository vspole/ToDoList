//
//  DataComponent.swift
//  UnderDogToDoList
//
//  Created by Vishal Polepalli on 11/10/22.
//

import Combine
import Foundation

/// The protocol for a component on the dependency container that holds central app state
protocol DataComponentProtocol: DependencyContainer.Component {
    var appState: Store<AppState> { get }
}

/// The component on the dependency container that holds central app state
class DataComponent: DependencyContainer.Component, DataComponentProtocol {
    let appState = Store<AppState>(AppState())
    private var cancellables = Set<AnyCancellable>()
}

// MARK: - Persistence

extension DataComponent: StartUpProtocol {
    var priority: StartUpPriority {
        .high
    }
    
    func startUp() {
        // On-load, retrieve any stored token from the token manager
        appState[\.userData.token] = container.tokenManager.retrieveToken()
        appState[\.userData.user] = container.firebaseAuthService.getCurrentUser()
        
        // When updating the token, auto-store in the token manager
        appState.publisher(for: \.userData.token)
            .sink { [weak self] token in
                self?.container.tokenManager.storeToken(token: token)
            }
            .store(in: &cancellables)
        
        // Refresh User ID Token if logged in
        if appState.value.isLoggedIn {
            container.firebaseAuthService.getUserIDToken { [weak self] userToken in
                guard let token = userToken else {
                    self?.container.alertService.presentGenericError()
                    return
                }
                self?.appState[\.userData.token] = token
            }
        }
    }
}
