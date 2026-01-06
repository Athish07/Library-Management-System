import Foundation

struct Book {
    let id: UUID
    let title: String
    let author: String
    let category: Category
    
    enum Category: String, CaseIterable {
        case fiction = "Fiction"
        case nonFiction = "Non-Fiction"
        case science = "Science"
        case technology = "Technology"
        case history = "History"
        case programming = "Programming"
        case other = "Other"
        
    }
    
    init(
        title: String,
        author: String,
        category: Category
    ) {
        
        self.id = UUID()
        self.title = title
        self.author = author
        self.category = category
    }
}

typealias BookCategory = Book.Category
