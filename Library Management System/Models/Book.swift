import Foundation

struct Book {
    let bookId: UUID
    var title: String
    var author: String
    var category: BookCategory
    var totalCopies: Int
    var availableCopies: Int
    
}

