import Foundation

protocol LibraryService {

    typealias BookWithInventory = (book: Book, inventory: BookInventory)
    
    func search(by query: String) -> [BookWithInventory]
    func getAvailableBooks() -> [BookWithInventory]
    func requestBorrow(bookId: UUID, by userId: UUID) throws
    func getBorrowedBooks(for userId: UUID) -> [IssuedBook]
    func returnBook(issueId: UUID, on returnDate: Date) throws -> Double
    func getBook(bookId: UUID) throws -> Book
    func addBook(
        title: String,
        author: String,
        category: BookCategory,
        copiesToAdd: Int
    ) throws
    func removeBook(bookId: UUID) throws
    func getAllBooks() -> [Book]
    func getAllPendingRequests() -> [BorrowRequest]
    func getAllIssuedBooks() -> [IssuedBook]
    func approveBorrowRequest(requestId: UUID) throws
    func rejectBorrowRequest(requestId: UUID) throws
    func renewBook(_ issueId: UUID) throws -> IssuedBook
}
