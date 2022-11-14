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
                TextField(viewModel.toDoItem.text, text: $viewModel.textFieldText, onEditingChanged: { editingChanged in
                    if !editingChanged {
                        viewModel.isEditing = false
                        viewModel.textFieldSubmitted()
                    }
                })
                    .scaledFont(type: .quickSandBold, size: 17, color: viewModel.textColor)
            } else {
                Text(viewModel.toDoItem.text)
                    .scaledFont(type: .quickSandBold, size: 17, color: viewModel.textColor)
            }
            HStack {
                Text(viewModel.toDoItem.dateString)
                    .scaledFont(type: .quickSandRegular, size: 13, color: TEXT_COLOR)
                Spacer()
                Button {
                    viewModel.completedButtonPressed()
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
        .onTapGesture() {
            viewModel.isEditing = true
        }
    }
}

extension ToDoItemView {
    class ViewModel: ObservableObject {
        @Published var toDoItem: ToDoItemModel
        @Published var isEditing = false
        @Published var textFieldText = ""
        
        var textColor: Color {
            toDoItem.completed ? COMPLETED_TEXT_COLOR : TEXT_COLOR
        }
        
        unowned var parentViewModel: ToDoListView.ViewModel
        
        init(parentViewModel: ToDoListView.ViewModel, toDoItem: ToDoItemModel) {
            self.toDoItem = toDoItem
            self.parentViewModel = parentViewModel
        }
        
        func resetTextField() {
            textFieldText = ""
            isEditing = false
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
        
        func completedButtonPressed() {
            parentViewModel.isLoading = true
            let newCompleted = !toDoItem.completed
            parentViewModel.toDoItemCompletedChanged(toDoItem.id, completed: newCompleted) { [weak self] error in
                if error != nil {
                    // TODO: Error handling here
                } else {
                    self?.toDoItem.completed = newCompleted
                }
                self?.parentViewModel.isLoading = false
            }
        }
    }
}
