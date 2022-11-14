//
//  ToDoItemView.swift
//  UnderDogToDoList
//
//  Created by Vishal Polepalli on 11/13/22.
//

import Foundation
import SwiftUI

struct ToDoItemView: View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: SIZE_PADDING_XS) {
            if viewModel.isEditing {
                TextField(viewModel.toDoItem.text, text: $viewModel.textFieldText)
                    .scaledFont(type: .quickSandBold, size: 17, color: TEXT_COLOR)
                    .onSubmit {
                        viewModel.isEditing = false
                        viewModel.textFieldSubmitted()
                    }
            } else {
                Text(viewModel.toDoItem.text)
                    .scaledFont(type: .quickSandBold, size: 17, color: TEXT_COLOR)
            }
            HStack {
                Text(viewModel.toDoItem.dateString)
                    .scaledFont(type: .quickSandRegular, size: 13, color: TEXT_COLOR)
                Spacer()
                Button {
                    //configuration.favoriteButtoncompletion(configuration.business)
                } label: {
                    Image(systemName: viewModel.toDoItem.completed ? "checkmark.circle.fill" : "checkmark.circle")
                        .foregroundColor(ACCENT_COLOR)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, MARGIN_SCREEN)
        .padding(.vertical, SIZE_PADDING_XXS)
        .onTapGesture(count: 2) {
            viewModel.isEditing = true
        }
    }
}

extension ToDoItemView {
    class ViewModel: ObservableObject {
        @Published var toDoItem: ToDoItemModel
        @Published var isEditing = false
        @Published var textFieldText = ""
        
        unowned var parentViewModel: ToDoListView.ViewModel
        
        init(parentViewModel: ToDoListView.ViewModel, toDoItem: ToDoItemModel) {
            self.toDoItem = toDoItem
            self.parentViewModel = parentViewModel
        }
        
        func textFieldSubmitted() {
            if !textFieldText.isEmpty && textFieldText != toDoItem.text {
                parentViewModel.isLoading = true
                parentViewModel.toDoItemTextChanged(toDoItem.id, newText: textFieldText) { [weak self] error in
                    if error != nil {
                        // TODO: Error handling here
                    } else {
                        guard let newText = self?.textFieldText else {
                            // TODO: Error handling here
                            return
                        }
                        self?.toDoItem.text = newText
                        self?.textFieldText = ""
                    }
                    self?.parentViewModel.isLoading = false
                }
            }
        }
    }
}
