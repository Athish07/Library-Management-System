import Foundation

struct Book {
    let bookId: UUID
    var title: String
    var author: String
    var category: Category
    let totalCopies: Int
    private(set) var availableCopies: Int
    
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
        category: Category,
        totalCopies: Int
    ) {

        self.bookId = UUID()
        self.title = title
        self.author = author
        self.category = category
        self.totalCopies = totalCopies
        self.availableCopies = totalCopies
    }
    
    


}

extension Book {
    
    mutating func issueCopy() -> Bool {
        guard availableCopies > 0 else { return false }
        availableCopies -= 1
        return true
    }
    
    mutating func returnCopy() {
        guard availableCopies < totalCopies else { return }
        availableCopies += 1
    }
}

typealias BookCategory = Book.Category

