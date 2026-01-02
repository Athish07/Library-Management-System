import Foundation

struct IssuedBook {
    let issueId: UUID
    let bookId: UUID
    let userId: UUID
    let issueDate: Date
    let dueDate: Date

    private(set) var returnDate: Date?
    private(set) var fineAmount: Double

    init(bookId: UUID, userId: UUID, issueDate: Date = Date(), dueDate: Date) {
        self.issueId = UUID()
        self.bookId = bookId
        self.userId = userId
        self.issueDate = issueDate
        self.dueDate = dueDate
        self.returnDate = nil
        self.fineAmount = 0.0
    }

}

extension IssuedBook {

    mutating func markReturned(on date: Date = Date()) -> Bool {
        guard returnDate == nil, date >= issueDate else {
            return false
        }
        returnDate = date
        return true
    }

    mutating func applyFine(_ amount: Double) {
        fineAmount = max(0, amount)
    }

    var isOverdue: Bool {
        returnDate == nil && Date() > dueDate
    }

    var daysOverdue: Int {
        guard returnDate == nil else { return 0 }

        let days =
            Calendar.current.dateComponents(
                [.day],
                from: dueDate,
                to: Date()
            ).day ?? 0
        return max(0, days)
    }

}
