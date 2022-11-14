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
    func fetchToDoItems(uid: String, completion: @escaping ([ToDoItemModel]?, Error?) -> Void)
    func fetchItem(uid: String, documentID: String, completion: @escaping (ToDoItemModel?, Error?) -> Void)
    func writeToDoItems(uid: String, toDoItem: ToDoItemModel, completion: @escaping (Error?) -> Void)
    func updateToDoItemText(uid: String, documentID: String, text: String, completion: @escaping (Error?) -> Void)
    func updateToDoItemStatus(uid: String, documentID: String, completed: Bool, completion: @escaping (Error?) -> Void)
}

class FirestoreService: DependencyContainer.Component, FirestoreServiceProtocol {
    private var db: Firestore?
    
    func fetchToDoItems(uid: String, completion: @escaping ([ToDoItemModel]?, Error?) -> Void) {
        db?.collection(uid).getDocuments() { (querySnapshot, error) in
            if let error = error {
                // TODO: Error Handling Here
                completion(nil, error)
            } else {
                if let querySnapshot = querySnapshot  {
                    var toDoListItems = [ToDoItemModel]()
                    for document in querySnapshot.documents {
                        do {
                            toDoListItems.append(try document.data(as: ToDoItemModel.self))
                        } catch {
                            completion(nil, error)
                            return
                        }
                    }
                    completion(toDoListItems, nil)
                } else {
                    completion(nil, nil)
                }
            }
        }
    }
    
    func fetchItem(uid: String, documentID: String, completion: @escaping (ToDoItemModel?, Error?) -> Void) {
        db?.collection(uid).document(documentID).getDocument(as: ToDoItemModel.self) { result in
            switch result {
            case .success(let toDoItem):
                completion(toDoItem, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func writeToDoItems(uid: String, toDoItem: ToDoItemModel, completion: @escaping (Error?) -> Void) {
        db?.collection(uid).document(toDoItem.id).setData(toDoItem.dictionaryFormat) { error in
            completion(error)
        }
    }
    
    func updateToDoItemText(uid: String, documentID: String, text: String, completion: @escaping (Error?) -> Void) {
        db?.collection(uid).document(documentID).updateData([ToDoItemModel.CodingKeys.text.rawValue: text]) { error in
            completion(error)
        }
    }
    
    func updateToDoItemStatus(uid: String, documentID: String, completed: Bool, completion: @escaping (Error?) -> Void) {
        db?.collection(uid).document(documentID).updateData([ToDoItemModel.CodingKeys.completed.rawValue: completed]) { error in
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
