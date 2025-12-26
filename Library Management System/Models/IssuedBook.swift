import Foundation

struct IssuedBook {
    let issueId: Int
    let bookId: Int
    let userId: Int
    let issueDate: Date
    let dueDate: Date
    var returnDate: Date? = nil
    var fineAmount: Double = 0.0
}

