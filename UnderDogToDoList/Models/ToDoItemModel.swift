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
    var id: String
    var text: String
    var completed: Bool
    let timestamp: Timestamp
    
    var dateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a 'on' MMMM dd, yyyy"
        return dateFormatter.string(from: timestamp.dateValue())
    }
        
    var dictionaryFormat: [String: Any] {
        [
            CodingKeys.text.rawValue: text,
            CodingKeys.completed.rawValue: completed,
            CodingKeys.timestamp.rawValue: timestamp,
            CodingKeys.id.rawValue: id
        ]
    }
    
    init(text: String, completed: Bool) {
        self.text = text
        self.completed = completed
        self.timestamp =  Timestamp(date: Date())
        self.id = UUID().uuidString
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case text
        case completed
        case timestamp
    }
}
