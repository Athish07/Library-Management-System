import Foundation

final class InMemoryIssuedBookRepository: IssuedBookRepository {
    
    private var issuedBooks: [UUID: IssuedBook] = [:]
    
    func save(_ issuedBook: IssuedBook) {
        issuedBooks[issuedBook.issueId] = issuedBook
    }
    
    func findById(_ issueId: UUID) -> IssuedBook? {
        issuedBooks[issueId]
    }
    
    func getIssuedBooks(for userId: UUID) -> [IssuedBook] {
        issuedBooks.values
            .filter { $0.userId == userId }
            .sorted { $0.issueDate > $1.issueDate } // Most recent first
    }
    
    func getAllIssuedBooks() -> [IssuedBook] {
        Array(issuedBooks.values)
            .sorted { $0.issueDate > $1.issueDate }
    }
    
    func getActiveIssuedBooks(for userId: UUID) -> [IssuedBook] {
        issuedBooks.values
            .filter { $0.userId == userId && $0.returnDate == nil }
            .sorted { $0.dueDate < $1.dueDate }
    }
}
