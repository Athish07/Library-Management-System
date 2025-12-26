import Foundation
struct IssuedBook {
    let issueId: UUID
    let bookId: UUID
    let userId: UUID
    let issueDate: Date
    let dueDate: Date
    var returnDate: Date? = nil
    var fineAmount: Double = 0.0
}

