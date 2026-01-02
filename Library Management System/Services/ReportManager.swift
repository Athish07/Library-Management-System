import Foundation

final class ReportManager: ReportService {

    private let userRepository: UserRepository
    private let bookRepository: BookRepository
    private let issuedBookRepository: IssuedBookRepository

    init(
        userRepository: UserRepository,
        bookRepository: BookRepository,
        issuedBookRepository: IssuedBookRepository,
    ) {
        self.userRepository = userRepository
        self.bookRepository = bookRepository
        self.issuedBookRepository = issuedBookRepository
    }

    func getIssuedBookHistory(bookId: UUID) throws -> [IssuedBookHistory] {

        guard let book = bookRepository.findById(bookId) else {
            throw ReportError.bookNotFound
        }

        let issues = issuedBookRepository.getAllIssuedBooks()
            .filter { $0.bookId == bookId }
            .sorted { $0.issueDate < $1.issueDate }

        let history = issues.compactMap { issued -> IssuedBookHistory? in
            guard let user = userRepository.findById(issued.userId) else {
                return nil
            }

            return IssuedBookHistory(
                bookTitle: book.title,
                author: book.author,
                userName: user.name,
                email: user.email
            )
        }
        return history
    }

    func getOverdueBooks() -> [OverdueBookItem] {
        let issues = issuedBookRepository.getAllIssuedBooks().filter {
            $0.isOverdue
        }

        let history = issues.compactMap { issued -> OverdueBookItem? in
            guard
                let book = bookRepository.findById(issued.bookId),
                let user = userRepository.findById(issued.userId)
            else { return nil }

            return OverdueBookItem(
                bookTitle: book.title,
                author: book.author,
                userName: user.name,
                daysOverdue: issued.daysOverdue
            )
        }

        return history
    }

}

extension ReportManager {

    enum ReportError: Error, LocalizedError {
        case bookNotFound
        case userNotFound

        var errorDescription: String? {
            switch self {
            case .bookNotFound: return "Book not found."
            case .userNotFound: return "User not found."
            }
        }
    }
}

