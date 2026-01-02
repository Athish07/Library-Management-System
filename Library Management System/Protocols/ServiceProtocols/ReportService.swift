import Foundation

struct IssuedBookHistory {
    let bookTitle: String
    let author: String
    let userName: String
    let email: String
}

struct OverdueBookItem {
    let bookTitle: String
    let author: String
    let userName: String
    let daysOverdue: Int
}


protocol ReportService {
    func getIssuedBookHistory(bookId: UUID) throws -> [IssuedBookHistory]
    func getOverdueBooks() -> [OverdueBookItem]
}
