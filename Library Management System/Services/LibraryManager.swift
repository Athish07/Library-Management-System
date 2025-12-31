import Foundation

enum LibraryError: Error, LocalizedError {
    case bookNotFound
    case bookUnavailable
    case duplicateBorrowRequest
    case issueNotFound
    case bookAlreadyReturned
    case invalidReturnDate
    case invalidCopyCount
    case bookCurrentlyIssued
    case requestNotFound
    case requestNotPending

    var errorDescription: String? {
        switch self {
        case .bookNotFound: return "Book not found."
        case .bookUnavailable: return "Book is not available for borrowing."
        case .duplicateBorrowRequest:
            return "You already have a pending request for this book."
        case .issueNotFound: return "Borrow record not found."
        case .bookAlreadyReturned:
            return "This book has already been returned."
        case .invalidReturnDate:
            return "Return date cannot be before issue date."
        case .invalidCopyCount:
            return "Number of copies must be greater than zero."
        case .bookCurrentlyIssued:
            return "Cannot remove book while copies are issued."
        case .requestNotFound: return "Borrow request not found."
        case .requestNotPending: return "Request is not pending."
        }
    }

}

final class LibraryManager: LibraryService {

    private let bookRepository: BookRepository
    private let borrowRequestRepository: BorrowRequestRepository
    private let issuedBookRepository: IssuedBookRepository

    private let finePerDay: Double = 1.0

    init(
        bookRepository: BookRepository,
        borrowRequestRepository: BorrowRequestRepository,
        issuedBookRepository: IssuedBookRepository
    ) {
        self.bookRepository = bookRepository
        self.borrowRequestRepository = borrowRequestRepository
        self.issuedBookRepository = issuedBookRepository
    }

    func search(by query: String) -> [Book] {
        let lowerQuery = query.lowercased().trimmingCharacters(in: .whitespaces)

        guard !lowerQuery.isEmpty else {
            return bookRepository.getAllBooks()
        }

        return bookRepository.getAllBooks()
            .filter { book in
                book.title.lowercased().contains(lowerQuery)
                    || book.author.lowercased().contains(lowerQuery)
                    || book.category.rawValue.lowercased().contains(lowerQuery)
            }
            .sorted { $0.title.lowercased() < $1.title.lowercased() }
    }

    func getAvailableBooks() -> [Book] {
        bookRepository.getAllBooks().filter { $0.availableCopies > 0 }
    }

    func requestBorrow(bookId: UUID, by userId: UUID) throws {

        guard let book = bookRepository.findById(bookId) else {
            throw LibraryError.bookNotFound
        }

        guard book.availableCopies > 0 else {
            throw LibraryError.bookUnavailable
        }

        let existing = borrowRequestRepository.getAllRequests().contains {
            request in
            request.bookId == bookId && request.userId == userId
                && request.status == .pending
        }

        guard !existing else {
            throw LibraryError.duplicateBorrowRequest
        }

        let request = BorrowRequest(userId: userId, bookId: bookId)
        borrowRequestRepository.save(request)
    }

    func getBorrowedBooks(for userId: UUID) -> [IssuedBook] {
        issuedBookRepository.getAllIssuedBooks().filter { $0.userId == userId }
    }

    func returnBook(issueId: UUID, on returnDate: Date = Date()) throws
        -> Double
    {
        guard var issuedBook = issuedBookRepository.findById(issueId) else {
            throw LibraryError.issueNotFound
        }

        guard issuedBook.returnDate == nil else {
            throw LibraryError.bookAlreadyReturned
        }

        guard issuedBook.markReturned(on: returnDate) else {
            throw LibraryError.invalidReturnDate
        }

        var fine: Double = 0.0
        if returnDate > issuedBook.dueDate {

            fine = finePerDay * Double(issuedBook.daysOverdue)
        }
        issuedBook.applyFine(fine)

        if var book = bookRepository.findById(issuedBook.bookId) {
            book.returnCopy()
            bookRepository.save(book)
        }

        issuedBookRepository.save(issuedBook)

        return fine
    }

    func addBook(
        title: String,
        author: String,
        category: BookCategory,
        totalCopies: Int
    ) throws {
        guard totalCopies > 0 else {
            throw LibraryError.invalidCopyCount
        }

        let book = Book(
            title: title,
            author: author,
            category: category,
            totalCopies: totalCopies
        )
        bookRepository.save(book)
    }

    func removeBook(bookId: UUID) throws {
        guard bookRepository.findById(bookId) != nil else {
            throw LibraryError.bookNotFound
        }

        let activeIssues = issuedBookRepository.getIssuedBooks(bookId: bookId)
            .contains { $0.returnDate == nil }
        guard !activeIssues else {
            throw LibraryError.bookCurrentlyIssued
        }

        bookRepository.remove(bookId: bookId)
    }

    func getAllBooks() -> [Book] {
        bookRepository.getAllBooks()
    }

    func getAllPendingRequests() -> [BorrowRequest] {
        borrowRequestRepository.getPendingRequests()
    }

    func getAllIssuedBooks() -> [IssuedBook] {
        issuedBookRepository.getAllIssuedBooks()
    }

    func getBook(bookId: UUID) throws -> Book {
        guard let book = bookRepository.findById(bookId) else {
            throw LibraryError.bookNotFound
        }

        return book
    }

    func approveBorrowRequest(requestId: UUID, dueInDays: Int = 14) throws {

        guard var request = borrowRequestRepository.findById(requestId) else {
            throw LibraryError.requestNotFound
        }

        guard let book = bookRepository.findById(request.bookId),
            book.availableCopies > 0
        else {
            throw LibraryError.bookUnavailable
        }

        var mutableBook = book
        guard mutableBook.issueCopy() else {
            throw LibraryError.bookUnavailable
        }
        bookRepository.save(mutableBook)

        let issueDate = Date()
        let dueDate = Calendar.current.date(
            byAdding: .day,
            value: dueInDays,
            to: issueDate
        )!
        // i need to confirm this.

        let issuedBook = IssuedBook(
            bookId: request.bookId,
            userId: request.userId,
            issueDate: issueDate,
            dueDate: dueDate
        )

        issuedBookRepository.save(issuedBook)

        if request.issue() {
            borrowRequestRepository.save(request)
        } else {
            throw LibraryError.requestNotPending
        }
    }

    func rejectBorrowRequest(requestId: UUID) throws {
        guard var request = borrowRequestRepository.findById(requestId) else {
            throw LibraryError.requestNotFound
        }

        if request.reject() {
            borrowRequestRepository.save(request)
        } else {
            throw LibraryError.requestNotPending
        }
    }

}

