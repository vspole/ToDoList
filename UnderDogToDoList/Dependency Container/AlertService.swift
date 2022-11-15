//
//  AlertService.swift
//  UnderDogToDoList
//
//  Created by Vishal Polepalli on 11/14/22.
//

import SwiftUI

typealias AlertAction = () -> Void

protocol AlertServiceProtocol {
    var alertType: AlertType? { get }
    var currentAlert: Alert { get }
    
    func present(_ value: AlertType)
    func presentGenericError()
    func dismiss()
}

class AlertService: DependencyContainer.Component, AlertServiceProtocol {
    var alertType: AlertType?
    
    var currentAlert: Alert {
        alertType?.createAlert() ?? AlertType.genericError(genericDismissAction).createAlert()
    }
    
    func present(_ value: AlertType) {
        alertType = value
    }
    
    func presentGenericError() {
        alertType = .genericError(genericDismissAction)
    }
    
    func dismiss() {
        alertType = nil
    }
    
    func genericDismissAction() {
        entity.appState.value.showAlert = false
    }
}

enum AlertType {
    case genericError(AlertAction)
}

extension AlertType {
    
    func createAlert() -> Alert {
        switch self {
        case .genericError(let action):
            return Alert(title: Text("Oops"),
                         message: Text("We encountered an error. Please try again"),
                         dismissButton: .default(Text("OK"), action: action))
        }
    }
}
