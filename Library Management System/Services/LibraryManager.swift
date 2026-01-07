import Foundation

final class LibraryManager: LibraryService {

    private let bookRepository: BookRepository
    private let borrowRequestRepository: BorrowRequestRepository
    private let issuedBookRepository: IssuedBookRepository
    private let bookInventoryRepository: BookInventoryRepository
    private let finePerDay: Double = 1.0
    private let dueInDays: Int = 14
    private let extensionDays: Int = 7

    init(
        bookRepository: BookRepository,
        borrowRequestRepository: BorrowRequestRepository,
        issuedBookRepository: IssuedBookRepository,
        bookInventoryRepository: BookInventoryRepository
    ) {
        self.bookRepository = bookRepository
        self.borrowRequestRepository = borrowRequestRepository
        self.issuedBookRepository = issuedBookRepository
        self.bookInventoryRepository = bookInventoryRepository
    }
    
    func search(by query: String) -> [BookWithInventory] {

        let normalized = query.lowercased()
        let books = normalized.isEmpty
            ? bookRepository.getAllBooks()
            : bookRepository.getAllBooks().filter {
                $0.title.lowercased().contains(normalized)
                || $0.author.lowercased().contains(normalized)
                || $0.category.rawValue.lowercased().contains(normalized)
            }

        return books.compactMap { book in
            guard let inventory =
                bookInventoryRepository.findByBookId(book.id)
            else { return nil }

            return (book: book, inventory: inventory)
        }
    }
    
    func getAvailableBooks() -> [BookWithInventory] {

        let books = bookRepository.getAllBooks()

        return books.compactMap { book in
            guard let inventory =
                    bookInventoryRepository.findByBookId(book.id),
                  inventory.isAvailable
            else {
                return nil
            }

            return (book: book, inventory: inventory)
        }
    }
    
    func requestBorrow(bookId: UUID, by userId: UUID) throws {

        guard bookRepository.findById(bookId) != nil else {
            throw LibraryError.bookNotFound
        }

        guard let inventory = bookInventoryRepository.findByBookId(bookId),
              inventory.isAvailable 
        else {
            throw LibraryError.bookUnavailable
        }

        let duplicate = borrowRequestRepository.getAllRequests().contains {
            $0.bookId == bookId && $0.userId == userId && $0.status == .pending
        }

        guard !duplicate else {
            throw LibraryError.duplicateBorrowRequest
        }

        borrowRequestRepository.save(
            BorrowRequest(userId: userId, bookId: bookId)
        )
    }
    
    func getBorrowedBooks(for userId: UUID) -> [IssuedBook] {
        issuedBookRepository.getAllIssuedBooks().filter { $0.userId == userId && $0.returnDate == nil }
    }
    
    func returnBook(issueId: UUID, on returnDate: Date) throws -> Double {

        guard var issued =
                issuedBookRepository.findById(issueId)
        else {
            throw LibraryError.issueNotFound
        }

        guard issued.markReturned(on: returnDate) else {
            throw LibraryError.invalidReturnDate
        }

        var fine = 0.0
        if returnDate > issued.dueDate {
            fine = finePerDay * Double(issued.daysOverdue)
        }

        issued.applyFine(fine)

        guard var inventory =
                bookInventoryRepository.findByBookId(issued.bookId)
        else { return fine }

        inventory.returnCopy()
        bookInventoryRepository.save(inventory)

        issuedBookRepository.save(issued)
        return fine
    }
    
    func renewBook(_ issueId: UUID) throws -> IssuedBook {

        guard var issued = issuedBookRepository.findById(issueId) else {
            throw LibraryError.issueNotFound
        }

        guard !issued.isOverdue else {
            throw LibraryError.cannotRenewOverdue
        }

        guard
            let newDueDate = Calendar.current.date(
                byAdding: .day,
                value: extensionDays,
                to: issued.dueDate
            ), issued.updateDueDate(updatedDate: newDueDate)
        else {
            fatalError("Date calculation failed")
        }

        issuedBookRepository.save(issued)
        return issued

    }

    func addBook(
        title: String,
        author: String,
        category: BookCategory,
        copiesToAdd: Int
    ) throws {

        guard copiesToAdd > 0 else {
            throw LibraryError.invalidCopyCount
        }

        if let existing = bookRepository.getAllBooks().first(where: {
            $0.title.lowercased() == title.lowercased()
                && $0.author.lowercased() == author.lowercased()
                && $0.category == category
        }) {

            guard var inventory =
                    bookInventoryRepository.findByBookId(existing.id)
            else { return }

            inventory.addCopies(copiesToAdd)
            bookInventoryRepository.save(inventory)

        } else {

            let book = Book(
                title: title,
                author: author,
                category: category
            )

            bookRepository.save(book)

            let inventory = BookQuantity(
                bookId: book.id,
                totalCopies: copiesToAdd
            )

            bookInventoryRepository.save(inventory)
        }
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
        borrowRequestRepository.getAllRequests().filter {
            $0.status == .pending
        }
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
    
    func approveBorrowRequest(requestId: UUID) throws {

        guard var request =
                borrowRequestRepository.findById(requestId)
        else {
            throw LibraryError.requestNotFound
        }

        guard var inventory =
                bookInventoryRepository.findByBookId(request.bookId),
            inventory.issueCopy()
        else {
            throw LibraryError.bookUnavailable
        }
        
        bookInventoryRepository.save(inventory)

        let issueDate = Date()
        
        guard
            let dueDate = Calendar.current.date(
                byAdding: .day,
                value: dueInDays,
                to: issueDate
            )
        else {
            fatalError("Date calculation failed")
        }
        
        let issuedBook = IssuedBook(
            bookId: request.bookId,
            userId: request.userId,
            issueDate: issueDate,
            dueDate: dueDate
        )

        issuedBookRepository.save(issuedBook)

        guard request.approve() else {
            throw LibraryError.requestNotPending
        }

        borrowRequestRepository.save(request)
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

extension LibraryManager {
    
    enum LibraryError: LocalizedError {
        case bookNotFound
        case bookUnavailable
        case duplicateBorrowRequest
        case issueNotFound
        case bookAlreadyReturned
        case invalidReturnDate
        case invalidCopyCount
        case bookCurrentlyIssued
        case cannotRenewOverdue
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
            case .cannotRenewOverdue:
                return "Cannot renew an Overdued"
            case .bookCurrentlyIssued:
                return "Cannot remove book while copies are issued."
            case .requestNotFound: return "Borrow request not found."
            case .requestNotPending: return "Request is not pending."
            }
        }

    }

}
