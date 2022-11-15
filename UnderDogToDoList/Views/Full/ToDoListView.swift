//
//  ToDoListView.swift
//  UnderDogToDoList
//
//  Created by Vishal Polepalli on 11/10/22.
//

import SwiftUI

struct ToDoListView: View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            tabBar
                .padding(.all, MARGIN_SCREEN)
            todoItems
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
extension ToDoListView {
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
extension ToDoListView {
    var todoItems: some View {
        ScrollView {
            LazyVStack() {
                ForEach(viewModel.showFiltered ? viewModel.filterdToDoItems : viewModel.toDoItems) { item in
                    ToDoItemView(viewModel: .init(parentViewModel: viewModel, toDoItem: item))
                }
            }
        }
    }
}

// MARK: View Model
extension ToDoListView {
    class ViewModel: ObservableObject {
        @Published var textFieldText = ""
        @Published var isEditing = false
        @Published var isLoading = false
        @Published var showFiltered = false
        @Published var toDoItems = [ToDoItemModel]()
        @Published var filterdToDoItems = [ToDoItemModel]()
        @Published var textFieldConfig:TextFieldConfiguration = .search
        @FocusState var focusedField: Bool?
        
        var container: DependencyContainer
        
        var uid: String {
            container.appState[\.userData.user]?.uid ?? ""
        }
        
        init(container: DependencyContainer) {
            self.container = container
        }
        
        func viewDidAppear(_ view: ToDoListView) {
            fetchToDoListItems()
        }
        
        func textFieldSubmitted() {
            if textFieldConfig == .add {
                addToDoListItem()
            } else {
                searchToDoListItems()
                showFiltered = true
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
        
        func toDoItemTextChanged(_ toDoItemId: String?, newText: String, completion: @escaping (Error?) -> Void) {
            guard let toDoItemId = toDoItemId else {
                // TODO: Error Handling Here
                return
            }
            
            container.firestoreService.updateToDoItemText(uid: uid, documentID: toDoItemId, text: newText) {  error in
                completion(error)
            }
        }
        
        func toDoItemCompletedChanged(_ toDoItemId: String?, completed: Bool, completion: @escaping (Error?) -> Void) {
            guard let toDoItemId = toDoItemId else {
                // TODO: Error Handling Here
                return
            }
            
            container.firestoreService.updateToDoItemStatus(uid: uid, documentID: toDoItemId, completed: completed) {  error in
                completion(error)
            }
        }
        
        func toDoItemDelete(_ toDoItemId: String?) {
            isLoading = true
            
            guard let toDoItemId = toDoItemId, let index = toDoItems.lazy.firstIndex(where: { $0.id == toDoItemId }) else {
                // TODO: Error Handling Here
                return
            }
            
            container.firestoreService.deleteToDoItem(uid: uid, documentID: toDoItemId) { [weak self] error in
                if error != nil {
                    // TODO: Error Handling Here
                } else {
                    self?.toDoItems.remove(at: index)
                }
                self?.isLoading = false
            }
        }
        
        private func addToDoListItem() {
            isLoading = true
            let toDoItem = ToDoItemModel(text: textFieldText, completed: false)
            container.firestoreService.writeToDoItems(uid: uid, toDoItem: toDoItem) { [weak self] (error) in
                if error != nil {
                    // TODO: Error handling here
                }
                self?.toDoItems.append(toDoItem)
                self?.textFieldText = ""
                self?.isLoading = false
            }
        }
        
        private func fetchToDoListItems() {
            isLoading = true
            container.firestoreService.fetchToDoItems(uid: uid) { [weak self] (items, error) in
                if error != nil {
                    // TODO: Error handling here
                } else if let items = items {
                    self?.toDoItems = items
                }
                self?.isLoading = false
            }
        }
        
        private func searchToDoListItems() {
            filterdToDoItems = toDoItems.filter { $0.text.lowercased().contains(textFieldText.lowercased())}
            print(filterdToDoItems)
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
