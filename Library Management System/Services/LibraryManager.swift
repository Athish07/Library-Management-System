import Foundation

final class LibraryManager: LibraryService {

    private let bookRepository: BookRepository
    private let borrowRequestRepository: BorrowRequestRepository
    private let issuedBookRepository: IssuedBookRepository

    private let finePerDay: Double = 1.0
    private let defaultDueDays: Int = 14

    init(
        bookRepository: BookRepository,
        borrowRequestRepository: BorrowRequestRepository,
        issuedBookRepository: IssuedBookRepository
    ) {
        self.bookRepository = bookRepository
        self.borrowRequestRepository = borrowRequestRepository
        self.issuedBookRepository = issuedBookRepository
    }

    func searchBooks(by query: String) -> [Book] {
        return bookRepository.search(by: query)
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
        issuedBookRepository.getIssuedBooks(for: userId)
            .filter { $0.returnDate == nil }
            .sorted { $0.dueDate < $1.dueDate }
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
            let overdueDays = max(0, issuedBook.daysOverdue)
            fine = finePerDay * Double(overdueDays)
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
        guard (bookRepository.findById(bookId) != nil) else {
            throw LibraryError.bookNotFound
        }

        let activeIssues = issuedBookRepository.getIssuedBooks(for: bookId)
            .contains { $0.returnDate == nil }
        guard !activeIssues else {
            throw LibraryError.bookCurrentlyIssued
        }

        bookRepository.remove(bookId: bookId)
    }

    func getAllBooks() -> [Book] {
        bookRepository.getAllBooks().sorted {
            $0.title.lowercased() < $1.title.lowercased()
        }
    }

    func getAllPendingRequests() -> [BorrowRequest] {
        borrowRequestRepository.getPendingRequests()
            .sorted { $0.requestDate < $1.requestDate }
    }

    func getAllIssuedBooks() -> [IssuedBook] {
        issuedBookRepository.getAllIssuedBooks()
            .sorted { $0.issueDate > $1.issueDate }
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

        guard request.status == .pending else {
            throw LibraryError.requestNotPending
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

        let issuedBook = IssuedBook(
            bookId: request.bookId,
            userId: request.userId,
            issueDate: issueDate,
            dueDate: dueDate
        )

        issuedBookRepository.save(issuedBook)
        request.issue()
        borrowRequestRepository.save(request)
    }

    func rejectBorrowRequest(requestId: UUID) throws {
        guard var request = borrowRequestRepository.findById(requestId) else {
            throw LibraryError.requestNotFound
        }

        guard request.status == .pending else {
            throw LibraryError.requestNotPending
        }

        request.reject()
        borrowRequestRepository.save(request)
    }
}

extension LibraryManager {
  
    func seedBookData() {
        
            guard getAllBooks().isEmpty else {
                return
            }
            
            print("Seeding initial data...")
        
            try? addBook(title: "Swift Programming: The Big Nerd Ranch Guide",
                         author: "Mikey Ward",
                         category: .programming,
                         totalCopies: 5)
            
            try? addBook(title: "Clean Architecture",
                         author: "Robert C. Martin",
                         category: .programming,
                         totalCopies: 3)
            
            try? addBook(title: "The Pragmatic Programmer",
                         author: "David Thomas",
                         category: .programming,
                         totalCopies: 4)
            
            try? addBook(title: "1984",
                         author: "George Orwell",
                         category: .fiction,
                         totalCopies: 6)
            
            try? addBook(title: "To Kill a Mockingbird",
                         author: "Harper Lee",
                         category: .fiction,
                         totalCopies: 4)
            
            try? addBook(title: "Sapiens",
                         author: "Yuval Noah Harari",
                         category: .history,
                         totalCopies: 3)
            
            try? addBook(title: "Cosmos",
                         author: "Carl Sagan",
                         category: .science,
                         totalCopies: 2)
            
            print("7 books added.")
        }
    
}
