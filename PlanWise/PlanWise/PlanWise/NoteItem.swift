//
//  NoteItem.swift
//  PlanWise
//
//  Created by user278444 on 11/8/25.
//

import Foundation
import SwiftData

@Model
final class NoteItem {
    var id: UUID
    var title: String
    var content: String
    var createdAt: Date
    var imageURL: String? // Store the selected Pixabay image URL
    
    init(title: String, content: String = "", createdAt: Date = Date(), imageURL: String? = nil) {
        self.id = UUID()
        self.title = title
        self.content = content
        self.createdAt = createdAt
        self.imageURL = imageURL
    }
}
