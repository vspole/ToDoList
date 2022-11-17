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
                TextField("", text: $viewModel.textFieldText, axis: .vertical)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Button("Save") {
                                viewModel.isEditing = false
                                viewModel.textFieldSubmitted()
                            }
                            .foregroundColor(ACCENT_COLOR)
                            Spacer()
                        }
                    }
                    .scaledFont(type: .quickSandBold, size: TEXT_FONT_MEDIUM, color: viewModel.textColor)
            } else {
                Text(viewModel.taskItem.text)
                    .scaledFont(type: .quickSandBold, size: TEXT_FONT_MEDIUM, color: viewModel.textColor)
            }
            HStack {
                Text(viewModel.taskItem.dateString)
                    .scaledFont(type: .quickSandRegular, size: TEXT_FONT_SMALL, color: TEXT_COLOR)
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

extension TaskListView {
    
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
            self.textFieldText = taskItem.text
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
