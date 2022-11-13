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
    func getToDoItems(uid: String, completion: @escaping ([ToDoItemModel]?, Error?) -> Void)
    func writeToDoItems(uid: String, toDoItem: ToDoItemModel, completion: @escaping (String?, Error?) -> Void)
    func updateToDoItem(uid: String, documentID: String, text: String, completion: @escaping (Error?) -> Void)
}

class FirestoreService: DependencyContainer.Component, FirestoreServiceProtocol {
    private var db: Firestore?
    
    func getToDoItems(uid: String, completion: @escaping ([ToDoItemModel]?, Error?) -> Void) {
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
    
    func writeToDoItems(uid: String, toDoItem: ToDoItemModel, completion: @escaping (String?, Error?) -> Void) {
        var ref: DocumentReference? = nil
        ref = db?.collection(uid).addDocument(data: toDoItem.dictionaryFormat) { error in
            if let error = error {
                completion(nil, error)
            } else {
                completion(ref?.documentID, error)
            }
        }
    }
    
    func updateToDoItem(uid: String, documentID: String, text: String, completion: @escaping (Error?) -> Void) {
        db?.collection(uid).document(documentID).updateData([ToDoItemModel.CodingKeys.text.rawValue: text]) { error in
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
