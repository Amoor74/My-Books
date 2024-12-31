import Foundation
import SwiftUI
import SwiftData

@Model
class Book {
    var title: String
    var author: String
    var summary: String
    var dateAdded: Date
    var dateStarted: Date
    var dateCompleted: Date
    var status: Status
    
    init(title: String, author: String,summary: String = " ", dateAdded: Date = Date.now,               dateStarted: Date = Date.distantPast, dateCompleted: Date = Date.distantPast,                    status: Status = .completed) {
        self.title = title
        self.author = author
        self.summary = summary
        self.dateAdded = dateAdded
        self.dateStarted = dateStarted
        self.dateCompleted = dateCompleted
        self.status = status
    }
    
    var icon: Image {
        switch status {
        case .onShelf:
            Image(systemName: "checkmark.diamond.fill")
        case .inProgress:
            Image(systemName: "book.fill")
        case .completed:
            Image(systemName: "books.vertical.fill")
        }
    }
}

enum Status: Int, Codable, Identifiable, CaseIterable {
    case onShelf, inProgress, completed
    var id: Self {
        self
    }
    
    var description: String {
        switch self {
        case .onShelf:
            "On Shelf"
        case .inProgress:
            "in Progress"
        case .completed:
            "Completed"
        }
    }
}
