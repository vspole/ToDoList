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
        }
    }
}

extension ToDoListView {
    var searchBar: some View {
        HStack {
            TextField("Search ...", text: $viewModel.searchText)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 10)
                .onTapGesture {
                    viewModel.isEditing = true
                }
                .onSubmit {
                    viewModel.isEditing = false
                    // TODO: Search todo list here
                }

            if viewModel.isEditing {
                Button(action: {
                    viewModel.searchText = ""
                    viewModel.isEditing = false
                    UIApplication.shared.endEditing()
                }) {
                    Text("Cancel")
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                .animation(.default, value: 5)
            }
        }
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
        @Published var searchText = ""
        @Published var isEditing = false
        @Published var isLoading = false
        @Published var todoItems = [ToDoItemModel]()
        
    }
}
