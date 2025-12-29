import Foundation

struct BorrowRequest {

    let requestId: UUID
    let userId: UUID
    let bookId: UUID
    let requestDate: Date

    private(set) var status: RequestStatus

    init(userId: UUID, bookId: UUID) {
        self.requestId = UUID()
        self.userId = userId
        self.bookId = bookId
        self.requestDate = Date()
        self.status = .pending
    }
}

extension BorrowRequest {

    @discardableResult
    mutating func issue() -> Bool {
        guard status == .pending else { return false }
        status = .issued
        return true
    }

    @discardableResult
    mutating func reject() -> Bool {
        guard status == .pending else { return false }
        status = .rejected
        return true
    }
    
    @discardableResult
    mutating func markReturned() -> Bool {
        guard status == .issued else { return false }
        status = .returned
        return true
    }
}
