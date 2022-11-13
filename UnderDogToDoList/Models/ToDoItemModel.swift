//
//  ToDoItemModel.swift
//  UnderDogToDoList
//
//  Created by Vishal Polepalli on 11/10/22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ToDoItemModel: Identifiable, Codable {
    @DocumentID var id: String?
    let text: String
    let completed: Bool
    let timestamp = Timestamp(date: Date())
    
    var dictionaryFormat: [String: Any] {
        [
            CodingKeys.text.rawValue: text,
            CodingKeys.completed.rawValue: completed,
            CodingKeys.timestamp.rawValue: timestamp,
        ]
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case text
        case completed
        case timestamp
    }
}
