//
//  ToDoItemModel.swift
//  UnderDogToDoList
//
//  Created by Vishal Polepalli on 11/10/22.
//

import Foundation

struct ToDoItemModel: Identifiable, Codable {
    let id: String
    let text: String
    let completed: Bool
    let dateAdded: String
}
