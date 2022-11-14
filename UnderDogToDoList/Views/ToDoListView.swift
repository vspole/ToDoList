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
            Spacer()
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: ACCENT_COLOR))
            }
        }
        .padding(.all, MARGIN_SCREEN)
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
            .cornerRadius(CORNER_RADIUS_TEXT_FIELD)
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
                    // TODO: List Item View here
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
        
        private func addToDoListItem() {
            isLoading = true
            var toDoItem = ToDoItemModel(text: textFieldText, completed: false)
            container.firestoreService.writeToDoItems(uid: uid, toDoItem: toDoItem) { [weak self] (documentID, error) in
                if error != nil {
                    // TODO: Error handling here
                } else if let documentID = documentID {
                    toDoItem.id = documentID
                    self?.toDoItems.append(toDoItem)
                    self?.textFieldText = ""
                }
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
