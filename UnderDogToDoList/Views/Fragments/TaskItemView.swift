//
//  TaskItemView.swift
//  UnderDogToDoList
//
//  Created by Vishal Polepalli on 11/13/22.
//

import Foundation
import SwiftUI

struct TaskItemView: View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: SIZE_PADDING_XS) {
            if viewModel.isEditing {
                TextField(viewModel.taskItem.text, text: $viewModel.textFieldText, onEditingChanged: { editingChanged in
                    if !editingChanged {
                        viewModel.isEditing = false
                        viewModel.textFieldSubmitted()
                    }
                })
                    .scaledFont(type: .quickSandBold, size: 17, color: viewModel.textColor)
            } else {
                Text(viewModel.taskItem.text)
                    .scaledFont(type: .quickSandBold, size: 17, color: viewModel.textColor)
            }
            HStack {
                Text(viewModel.taskItem.dateString)
                    .scaledFont(type: .quickSandRegular, size: 13, color: TEXT_COLOR)
                Spacer()
                Button {
                    viewModel.completedButtonPressed()
                } label: {
                    Image(systemName: viewModel.taskItem.completed ? "checkmark.circle.fill" : "checkmark.circle")
                        .foregroundColor(ACCENT_COLOR)
                }
                Button {
                    viewModel.deleteButtonPressed()
                } label: {
                    Image(systemName: "trash.circle.fill")
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

extension TaskItemView {
    class ViewModel: ObservableObject {
        @Published var taskItem: TaskItemModel
        @Published var isEditing = false
        @Published var textFieldText = ""
        
        var textColor: Color {
            taskItem.completed ? COMPLETED_TEXT_COLOR : TEXT_COLOR
        }
        
        unowned var parentViewModel: TaskListView.ViewModel
        
        init(parentViewModel: TaskListView.ViewModel, taskItem: TaskItemModel) {
            self.taskItem = taskItem
            self.parentViewModel = parentViewModel
        }
        
        func resetTextField() {
            textFieldText = ""
            isEditing = false
        }
        
        func textFieldSubmitted() {
            if !textFieldText.isEmpty && textFieldText != taskItem.text {
                parentViewModel.isLoading = true
                parentViewModel.taskItemTextChanged(taskItem.id, newText: textFieldText) { [weak self] error in
                    if error != nil {
                        self?.parentViewModel.container.alertService.presentGenericError()
                    } else {
                        guard let newText = self?.textFieldText else {
                            self?.parentViewModel.container.alertService.presentGenericError()
                            return
                        }
                        self?.taskItem.text = newText
                        self?.textFieldText = ""
                    }
                    self?.parentViewModel.isLoading = false
                }
            }
        }
        
        func completedButtonPressed() {
            parentViewModel.isLoading = true
            let newCompleted = !taskItem.completed
            parentViewModel.taskItemCompletedChanged(taskItem.id, completed: newCompleted) { [weak self] error in
                if error != nil {
                    self?.parentViewModel.container.alertService.presentGenericError()
                } else {
                    self?.taskItem.completed = newCompleted
                }
                self?.parentViewModel.isLoading = false
            }
        }
        
        func deleteButtonPressed() {
            parentViewModel.taskItemDelete(taskItem.id)
        }
    }
}
