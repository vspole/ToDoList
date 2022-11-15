//
//  MainView.swift
//  UnderDogToDoList
//
//  Created by Vishal Polepalli on 11/10/22.
//

import SwiftUI
import FirebaseAuth
import Combine

struct MainView: View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        NavigationStack {
            if viewModel.isUserLoggedIn {
                TaskListView(viewModel: .init(container: viewModel.container))
            } else {
                PhoneLoginView(viewModel: .init(container: viewModel.container, mainViewModel: viewModel))
            }
        }
        .onAppear {
            viewModel.viewDidAppear(self)
        }
        .alert(isPresented: $viewModel.showAlert) {
            viewModel.container.alertService.currentAlert
        }
    }
}

extension MainView {
    class ViewModel: ObservableObject {
        @Published var isUserLoggedIn = false
        @Published var showAlert = false {
            didSet {
                if !showAlert {
                    container.alertService.dismiss()
                }
            }
        }
        
        private var cancellables = Set<AnyCancellable>()
        var container: DependencyContainer
        
        init(container: DependencyContainer) {
            self.container = container
            
            container.appState.publisher(for: \.showAlert)
                .sink { [weak self] showAlert in
                    self?.showAlert = showAlert
                }
                .store(in: &cancellables)
        }
        
        func viewDidAppear(_ view: MainView) {
            isUserLoggedIn = container.appState.value.isLoggedIn
        }
    }
}
