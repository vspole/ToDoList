//
//  AppState.swift
//  UnderDogToDoList
//
//  Created by Vishal Polepalli on 11/10/22.
//

import Combine

/// Redux-like centralized AppState as the single source of truth
struct AppState: Equatable {
    var isLoggedIn: Bool { !userData.token.isEmpty }
    var userData = UserData()
}

// MARK: - User Data
extension AppState {
    /// Source of truth for application data related to the current user
    struct UserData: Equatable {
        var token: String = ""
    }
}
