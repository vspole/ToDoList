//
//  TaskListView.swift
//  UnderDogToDoList
//
//  Created by Vishal Polepalli on 11/10/22.
//

import SwiftUI

struct TaskListView: View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            tabBar
                .padding(.all, MARGIN_SCREEN)
            taskItemsView
            Spacer()
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: ACCENT_COLOR))
            }
        }
        .onAppear {
            viewModel.viewDidAppear(self)
        }
    }
}

// MARK: Tab Bar
extension TaskListView {
    var tabBar: some View {
        HStack {
            imageButton
            textField
            if viewModel.isEditing {
                cancelButton
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: SIZE_HEIGHT_TEXTFIELD)
    }
    
    var imageButton: some View {
        Image(systemName: viewModel.textFieldConfig.oppisiteImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(ACCENT_COLOR)
            .padding(.vertical, SIZE_PADDING_XXS)
            .onTapGesture {
                viewModel.imageButtonPressed()
            }
    }
    
    var textField: some View {
        TextField(viewModel.textFieldConfig.rawValue, text: $viewModel.textFieldText)
            .padding(SIZE_PADDING_SMALL)
            .background(Color(.systemGray6))
            .cornerRadius(CORNER_RADIUS)
            .onTapGesture {
                viewModel.isEditing = true
            }
            .onSubmit {
                viewModel.isEditing = false
                viewModel.textFieldSubmitted()
            }
    }
    
    var cancelButton: some View {
        Button(action: {
            viewModel.cancelButtonPressed()
        }) {
            Text("Cancel")
        }
        .transition(.move(edge: .trailing))
        .animation(.default, value: 5)
    }
}

// MARK: Items List
extension TaskListView {
    var taskItemsView: some View {
        ScrollView {
            LazyVStack() {
                ForEach(viewModel.showFiltered ? viewModel.filteredTaskItems : viewModel.taskItems) { item in
                    TaskItemView(viewModel: .init(parentViewModel: viewModel, taskItem: item))
                }
            }
        }
    }
}

// MARK: View Model
extension TaskListView {
    class ViewModel: ObservableObject {
        @Published var textFieldText = ""
        @Published var isEditing = false
        @Published var isLoading = false
        @Published var showFiltered = false
        @Published var taskItems = [TaskItemModel]()
        @Published var filteredTaskItems = [TaskItemModel]()
        @Published var textFieldConfig:TextFieldConfiguration = .search
        @FocusState var focusedField: Bool?
        
        var container: DependencyContainer
        
        var uid: String {
            container.appState[\.userData.user]?.uid ?? ""
        }
        
        init(container: DependencyContainer) {
            self.container = container
        }
        
        func viewDidAppear(_ view: TaskListView) {
            fetchTaskItems()
        }
        
        func textFieldSubmitted() {
            if textFieldConfig == .add {
                addTaskItem()
            } else {
                searchTaskItems()
            }
        }
        
        func cancelButtonPressed() {
            textFieldConfig = .search
            textFieldText = ""
            isEditing = false
            showFiltered = false
            UIApplication.shared.endEditing()
        }
        
        func imageButtonPressed() {
            textFieldConfig.setOppositeValue()
            textFieldText = ""
        }
        
        func taskItemTextChanged(_ taskItemId: String?, newText: String, completion: @escaping (Error?) -> Void) {
            guard let taskItemId = taskItemId else {
                container.alertService.presentGenericError()
                return
            }
            
            container.firestoreService.updateTaskItemText(uid: uid, documentID: taskItemId, text: newText) {  error in
                completion(error)
            }
        }
        
        func taskItemCompletedChanged(_ taskItemId: String?, completed: Bool, completion: @escaping (Error?) -> Void) {
            guard let taskItemId = taskItemId else {
                container.alertService.presentGenericError()
                return
            }
            
            container.firestoreService.updateTaskItemStatus(uid: uid, documentID: taskItemId, completed: completed) {  error in
                completion(error)
            }
        }
        
        func taskItemDelete(_ taskItemId: String?) {
            isLoading = true
            
            guard let taskItemId = taskItemId, let index = taskItems.lazy.firstIndex(where: { $0.id == taskItemId }) else {
                container.alertService.presentGenericError()
                return
            }
            
            container.firestoreService.deleteTaskItem(uid: uid, documentID: taskItemId) { [weak self] error in
                if error != nil {
                    self?.container.alertService.presentGenericError()
                } else {
                    self?.taskItems.remove(at: index)
                }
                self?.isLoading = false
            }
        }
        
        private func addTaskItem() {
            guard !textFieldText.isEmpty else {
                return
            }
            
            isLoading = true
            let newTaskItem = TaskItemModel(text: textFieldText, completed: false)
            container.firestoreService.writeTaskItem(uid: uid, taskItem: newTaskItem) { [weak self] (error) in
                if error != nil {
                    self?.container.alertService.presentGenericError()
                }
                self?.taskItems.insert(newTaskItem, at: 0)
                self?.textFieldText = ""
                self?.isLoading = false
            }
        }
        
        private func fetchTaskItems() {
            isLoading = true
            container.firestoreService.fetchTaskItems(uid: uid) { [weak self] (items, error) in
                if error != nil {
                    self?.container.alertService.presentGenericError()
                } else if let items = items {
                    self?.taskItems = items.sorted(by: { $0.date.compare($1.date) == .orderedDescending })
                }
                self?.isLoading = false
            }
        }
        
        private func searchTaskItems() {
            guard !textFieldText.isEmpty else {
                showFiltered = false
                return
            }
            
            filteredTaskItems = taskItems.filter { $0.text.lowercased().contains(textFieldText.lowercased())}
            showFiltered = true
        }
    }
}

enum TextFieldConfiguration: String {
    case search = "Search ..."
    case add = "Add item..."
    
    var oppisiteImage: String {
        return self == .search ? "plus.square" : "magnifyingglass"
    }
    
    mutating func setOppositeValue() {
        self = self == .search ? .add : .search
    }
}
