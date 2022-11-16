//
//  TaskListViewModelTests.swift
//  UnderDogToDoListTests
//
//  Created by Vishal Polepalli on 11/16/22.
//

@testable import UnderDogToDoList
import XCTest

final class TaskListViewModelTests: TestDependencyContainer {
    var taskListViewModel: TaskListView.ViewModel!
    var taskListView: TaskListView!
    
    var mockFirestoreService: MockFirestoreService {
        container.mockFirestoreService
    }
    
    override func setUpWithError() throws {
        container = DependencyContainer().createTestDependencyContainer()
        taskListViewModel = .init(container: container)
        taskListView = TaskListView(viewModel: self.taskListViewModel)
    }

    override func tearDownWithError() throws {
        container = nil
    }
    
    func test_viewDidApper() {
        taskListViewModel.viewDidAppear(taskListView)
        
        XCTAssertEqual(mockFirestoreService.fetchTaskItemsCallCount, 1)
    }
    
    func test_imageButtonPressed() {
        taskListViewModel.textFieldConfig = .add
        taskListViewModel.textFieldText = "Test"
        taskListViewModel.imageButtonPressed()
        XCTAssertEqual(taskListViewModel.textFieldConfig, .search)
        XCTAssertEqual(taskListViewModel.textFieldText, "")
        
        taskListViewModel.textFieldConfig = .search
        taskListViewModel.textFieldText = "Test"
        taskListViewModel.imageButtonPressed()
        XCTAssertEqual(taskListViewModel.textFieldConfig, .add)
        XCTAssertEqual(taskListViewModel.textFieldText, "")
    }
    
    func test_cancelButtonPressed() {
        taskListViewModel.textFieldConfig = .add
        taskListViewModel.textFieldText = "Test"
        taskListViewModel.isEditing = true
        taskListViewModel.showFiltered = true
        
        taskListViewModel.cancelButtonPressed()
        XCTAssertEqual(taskListViewModel.textFieldConfig, .search)
        XCTAssertEqual(taskListViewModel.textFieldText, "")
        XCTAssertEqual(taskListViewModel.isEditing, false)
        XCTAssertEqual(taskListViewModel.showFiltered, false)
    }
    
    func test_textFieldSubmitted() {
        taskListViewModel.textFieldConfig = .add
        taskListViewModel.textFieldSubmitted()
        XCTAssertEqual(container.mockFirestoreService.writeTaskItemCallCount, 0)
        
        taskListViewModel.textFieldConfig = .search
        taskListViewModel.textFieldText = "Test"
        taskListViewModel.textFieldSubmitted()
        XCTAssertEqual(container.mockFirestoreService.writeTaskItemCallCount, 0)
        
        taskListViewModel.textFieldConfig = .add
        taskListViewModel.textFieldText = "Test"
        taskListViewModel.textFieldSubmitted()
        XCTAssertEqual(container.mockFirestoreService.writeTaskItemCallCount, 1)
    }
    
    func test_taskItemTextChanged() {
        var taskItemID: String? = nil
        taskListViewModel.taskItemTextChanged(taskItemID, newText: "") {_ in }
        XCTAssertEqual(container.mockFirestoreService.updateTaskItemTextCallCount, 0)
        
        taskItemID = "test"
        taskListViewModel.taskItemTextChanged(taskItemID, newText: "") {_ in }
        XCTAssertEqual(container.mockFirestoreService.updateTaskItemTextCallCount, 1)
    }
    
    func test_taskItemStatusChanged() {
        var taskItemID: String? = nil
        taskListViewModel.taskItemCompletedChanged(taskItemID, completed: false) {_ in }
        XCTAssertEqual(container.mockFirestoreService.updateTaskItemStatusCallCount, 0)
        
        taskItemID = "test"
        taskListViewModel.taskItemCompletedChanged(taskItemID, completed: false) {_ in }
        XCTAssertEqual(container.mockFirestoreService.updateTaskItemStatusCallCount, 1)
    }
    
    func test_taskItemDelete() {
        let testTask1 = TaskItemModel(text: "1", completed: false)
        let testTask2 = TaskItemModel(text: "2", completed: false)
        let testTask3 = TaskItemModel(text: "3", completed: false)
        taskListViewModel.taskItems = [testTask1, testTask2, testTask3]
        
        var taskItemID: String? = nil
        taskListViewModel.taskItemDelete(taskItemID)
        XCTAssertEqual(container.mockFirestoreService.deleteTaskItemCallCount, 0)
        
        taskItemID = testTask2.id
        taskListViewModel.taskItemCompletedChanged(taskItemID, completed: false) {_ in }
        XCTAssertEqual(container.mockFirestoreService.updateTaskItemStatusCallCount, 1)
    }

    func test_filterTaskItems() {
        let testTask1 = TaskItemModel(text: "1", completed: false)
        let testTask2 = TaskItemModel(text: "2", completed: false)
        let testTask3 = TaskItemModel(text: "3", completed: false)
        taskListViewModel.taskItems = [testTask1, testTask2, testTask3]
        taskListViewModel.textFieldText = "2"
        taskListViewModel.textFieldConfig = .search
        taskListViewModel.textFieldSubmitted()
        
        XCTAssertEqual(taskListViewModel.filteredTaskItems.first?.id, testTask2.id)
    }
}
