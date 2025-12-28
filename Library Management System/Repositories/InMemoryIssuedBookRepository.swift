import Foundation

final class InMemoryIssuedBookRepository: IssuedBookRepository {

    private var issuedBooks: [UUID: IssuedBook] = [:]

    func save(_ issuedBook: IssuedBook) {
        issuedBooks[issuedBook.issueId] = issuedBook
    }

    func findById(_ issueId: UUID) -> IssuedBook? {
        issuedBooks[issueId]
    }

    func findByUserId(_ userId: UUID) -> [IssuedBook] {
        issuedBooks.values.filter { $0.userId == userId }
    }

    func findAll() -> [IssuedBook] {
        Array(issuedBooks.values)
    }
}

