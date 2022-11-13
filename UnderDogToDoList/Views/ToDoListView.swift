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
            searchBar
            Spacer()
        }
        .padding(.horizontal, MARGIN_SCREEN_LEFT_RIGHT)
    }
}

extension ToDoListView {
    var searchBar: some View {
        HStack {
            Image(systemName: viewModel.textFieldConfig.oppisiteImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(ACCENT_COLOR)
                .padding(.vertical, SIZE_PADDING_XXS)
                .onTapGesture {
                    viewModel.imageButtonPressed()
                }

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

            if viewModel.isEditing {
                Button(action: {
                    viewModel.cancelButtonPressed()
                }) {
                    Text("Cancel")
                }
                .transition(.move(edge: .trailing))
                .animation(.default, value: 5)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: SIZE_HEIGHT_TEXTFIELD)
    }
    
    var todoItems: some View {
        ScrollView {
            LazyVStack() {
                ForEach(viewModel.todoItems) { item in
                    // TODO: List Item View here
                }
            }
        }
    }
}

extension ToDoListView {
    class ViewModel: ObservableObject {
        @Published var textFieldText = ""
        @Published var isEditing = false
        @Published var isLoading = false
        @Published var todoItems = [ToDoItemModel]()
        @Published var textFieldConfig:TextFieldConfiguration = .search
        @FocusState var focusedField: Bool?
        
        var container: DependencyContainer
        
        init(container: DependencyContainer) {
            self.container = container
        }
        
        func textFieldSubmitted() {
            if textFieldConfig == .add {
                addToDoListItem()
            } else {
                searchToDoListItems()
            }
        }
        
        func cancelButtonPressed() {
            textFieldConfig = .search
            textFieldText = ""
            isEditing = false
            UIApplication.shared.endEditing()
        }
        
        func imageButtonPressed() {
            textFieldConfig.setOppositeValue()
            textFieldText = ""
        }
        
        private func addToDoListItem() {
            
        }
        
        private func searchToDoListItems() {
            
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
