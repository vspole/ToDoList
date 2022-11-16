//
//  MockFirestroreService.swift
//  UnderDogToDoListTests
//
//  Created by Vishal Polepalli on 11/16/22.
//

@testable import UnderDogToDoList
import Foundation

class MockFirestoreService: DependencyContainer.Component, FirestoreServiceProtocol {
    
    private(set) var fetchTaskItemsCallCount = 0
    private(set) var fetchTaskItemCallCount = 0
    private(set) var writeTaskItemCallCount = 0
    private(set) var updateTaskItemTextCallCount = 0
    private(set) var updateTaskItemStatusCallCount = 0
    private(set) var deleteTaskItemCallCount = 0
    
    func fetchTaskItems(uid: String, completion: @escaping ([UnderDogToDoList.TaskItemModel]?, Error?) -> Void) {
        fetchTaskItemsCallCount += 1
    }
    
    func fetchTaskItem(uid: String, documentID: String, completion: @escaping (UnderDogToDoList.TaskItemModel?, Error?) -> Void) {
        fetchTaskItemCallCount += 1
    }
    
    func writeTaskItem(uid: String, taskItem: UnderDogToDoList.TaskItemModel, completion: @escaping (Error?) -> Void) {
        writeTaskItemCallCount += 1
    }
    
    func updateTaskItemText(uid: String, documentID: String, text: String, completion: @escaping (Error?) -> Void) {
        updateTaskItemTextCallCount += 1
    }
    
    func updateTaskItemStatus(uid: String, documentID: String, completed: Bool, completion: @escaping (Error?) -> Void) {
        updateTaskItemStatusCallCount += 1
    }
    
    func deleteTaskItem(uid: String, documentID: String, completion: @escaping (Error?) -> Void) {
        deleteTaskItemCallCount += 1
    }
    
    
}
