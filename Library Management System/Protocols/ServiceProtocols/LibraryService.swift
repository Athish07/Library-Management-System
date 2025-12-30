import Foundation

protocol LibraryService {
    
    func search(by query: String) -> [Book]
    func getAvailableBooks() -> [Book]
    func requestBorrow(bookId: UUID, by userId: UUID) throws
    func getBorrowedBooks(for userId: UUID) -> [IssuedBook]
    func returnBook(issueId: UUID, on returnDate: Date) throws -> Double
    func getBook(bookId: UUID) throws -> Book
    func addBook(
        title: String,
        author: String,
        category: BookCategory,
        totalCopies: Int
    ) throws
    func removeBook(bookId: UUID) throws
    func getAllBooks() -> [Book]
    func getAllPendingRequests() -> [BorrowRequest]
    func getAllIssuedBooks() -> [IssuedBook]
    func approveBorrowRequest(requestId: UUID, dueInDays: Int) throws
    func rejectBorrowRequest(requestId: UUID) throws
    func seedBookData()
}

extension LibraryService {
    func returnBook(issueId: UUID) throws -> Double {
        try returnBook(issueId: issueId, on: Date())
    }

    func approveBorrowRequest(requestId: UUID) throws {
        try approveBorrowRequest(
            requestId: requestId,
            dueInDays: 14
        )
    }
}
