//
//  ToDoItemView.swift
//  UnderDogToDoList
//
//  Created by Vishal Polepalli on 11/13/22.
//

import Foundation
import SwiftUI

struct ToDoItemView: View {
    let configuration: Configuration
    
    var body: some View {
        VStack(alignment: .leading, spacing: SIZE_PADDING_XS) {
            Text(configuration.toDoItem.text)
                .scaledFont(type: .quickSandBold, size: 17, color: TEXT_COLOR)
            HStack {
                Text(configuration.toDoItem.dateString)
                    .scaledFont(type: .quickSandRegular, size: 13, color: TEXT_COLOR)
                Spacer()
                Button {
                    //configuration.favoriteButtoncompletion(configuration.business)
                } label: {
                    Image(systemName: configuration.toDoItem.completed ? "checkmark.circle.fill" : "checkmark.circle")
                        .foregroundColor(ACCENT_COLOR)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, MARGIN_SCREEN)
        .padding(.vertical, SIZE_PADDING_XXS)
    }
}

extension ToDoItemView {
    struct Configuration {
        let toDoItem: ToDoItemModel
        
        init(toDoItem: ToDoItemModel) {
            self.toDoItem = toDoItem
        }
    }
}
