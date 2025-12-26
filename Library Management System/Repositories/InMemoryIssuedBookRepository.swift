import Foundation

class InMemoryIssuedBookRepository: IssuedBookRepository {
    
    private var issuedBooks: [UUID: IssuedBook] = [:]
    
    func save(_ issuedBook: IssuedBook) {
        issuedBooks[issuedBook.issueId] = issuedBook
    }
    
    func getIssuedBooks(_ userId: UUID) -> [IssuedBook] {
        issuedBooks.values.filter{ $0.userId == userId }
    }
        
}
