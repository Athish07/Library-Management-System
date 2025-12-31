import Foundation

typealias IssuedBookHistory = (
    bookTitle: String,
    author: String,
    userName: String,
    email: String
)

typealias overDueBookItem = (
    bookTitle: String,
    author: String,
    userName: String,
    daysOverdue: Int
)

protocol ReportService {
    func getIssuedBookHistory(bookId: UUID) throws -> [IssuedBookHistory]
    func getOverDueBooks() -> [overDueBookItem]
}
