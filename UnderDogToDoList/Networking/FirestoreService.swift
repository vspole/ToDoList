//
//  FirestoreService.swift
//  UnderDogToDoList
//
//  Created by Vishal Polepalli on 11/13/22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol FirestoreServiceProtocol: AnyObject {
    func fetchTaskItems(uid: String, completion: @escaping ([TaskItemModel]?, Error?) -> Void)
    func fetchTaskItem(uid: String, documentID: String, completion: @escaping (TaskItemModel?, Error?) -> Void)
    func writeTaskItem(uid: String, taskItem: TaskItemModel, completion: @escaping (Error?) -> Void)
    func updateTaskItemText(uid: String, documentID: String, text: String, completion: @escaping (Error?) -> Void)
    func updateTaskItemStatus(uid: String, documentID: String, completed: Bool, completion: @escaping (Error?) -> Void)
    func deleteTaskItem(uid: String, documentID: String, completion: @escaping (Error?) -> Void)
}

class FirestoreService: DependencyContainer.Component, FirestoreServiceProtocol {
    private var db: Firestore?
    
    func fetchTaskItems(uid: String, completion: @escaping ([TaskItemModel]?, Error?) -> Void) {
        db?.collection(uid).getDocuments() { [weak self] (querySnapshot, error) in
            if let error = error {
                self?.entity.alertService.presentGenericError()
                completion(nil, error)
            } else {
                if let querySnapshot = querySnapshot  {
                    var taksListItems = [TaskItemModel]()
                    for document in querySnapshot.documents {
                        do {
                            taksListItems.append(try document.data(as: TaskItemModel.self))
                        } catch {
                            completion(nil, error)
                            return
                        }
                    }
                    completion(taksListItems, nil)
                } else {
                    completion(nil, nil)
                }
            }
        }
    }
    
    func fetchTaskItem(uid: String, documentID: String, completion: @escaping (TaskItemModel?, Error?) -> Void) {
        db?.collection(uid).document(documentID).getDocument(as: TaskItemModel.self) { result in
            switch result {
            case .success(let taskItem):
                completion(taskItem, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func writeTaskItem(uid: String, taskItem: TaskItemModel, completion: @escaping (Error?) -> Void) {
        db?.collection(uid).document(taskItem.id).setData(taskItem.dictionaryFormat) { error in
            completion(error)
        }
    }
    
    func updateTaskItemText(uid: String, documentID: String, text: String, completion: @escaping (Error?) -> Void) {
        db?.collection(uid).document(documentID).updateData([TaskItemModel.CodingKeys.text.rawValue: text]) { error in
            completion(error)
        }
    }
    
    func updateTaskItemStatus(uid: String, documentID: String, completed: Bool, completion: @escaping (Error?) -> Void) {
        db?.collection(uid).document(documentID).updateData([TaskItemModel.CodingKeys.completed.rawValue: completed]) { error in
            completion(error)
        }
    }
    
    func deleteTaskItem(uid: String, documentID: String, completion: @escaping (Error?) -> Void) {
        db?.collection(uid).document(documentID).delete() { error in
            completion(error)
        }
    }
}

extension FirestoreService: StartUpProtocol {
    var priority: StartUpPriority {
        .high
    }
    
    func startUp() {
        db = Firestore.firestore()
    }
}
