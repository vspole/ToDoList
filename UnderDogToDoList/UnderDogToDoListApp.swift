//
//  UnderDogToDoListApp.swift
//  UnderDogToDoList
//
//  Created by Vishal Polepalli on 11/10/22.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseMessaging

class AppDelegate: NSObject, UIApplicationDelegate {
    
    var dependencyContainer = DependencyContainer.create()
    
    func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      FirebaseApp.configure()
      application.registerForRemoteNotifications()
      dependencyContainer.startUp()
      return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      Auth.auth().setAPNSToken(deviceToken, type: .unknown)
      Messaging.messaging().setAPNSToken(deviceToken, type: .unknown)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification notification: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    if Auth.auth().canHandleNotification(notification) {
      completionHandler(.noData)
      return
    }
    }

    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
    if Auth.auth().canHandle(url) {
      return true
    }
    return false
    }
}

@main
struct UnderDogToDoListApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var dependencyContainer: DependencyContainer {
        return delegate.dependencyContainer
    }
    
    var body: some Scene {
        WindowGroup {
            MainView(viewModel: .init(container: dependencyContainer))
        }
    }
}

