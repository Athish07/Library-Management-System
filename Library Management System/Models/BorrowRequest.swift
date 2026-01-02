import Foundation

struct BorrowRequest {

    let requestId: UUID
    let userId: UUID
    let bookId: UUID
    let requestDate: Date

    private(set) var status: RequestStatus
    
    enum RequestStatus: String {
        case pending = "Pending"
        case approved = "Approved"
        case rejected = "Rejected"
    }
    
    init(userId: UUID, bookId: UUID) {
        self.requestId = UUID()
        self.userId = userId
        self.bookId = bookId
        self.requestDate = Date()
        self.status = .pending
    }
}

extension BorrowRequest {

    mutating func approve() -> Bool {
        guard status == .pending else { return false }
        status = .approved
        return true
    }
    
    mutating func reject() -> Bool {
        guard status == .pending else { return false }
        status = .rejected
        return true
    }
    
}

typealias RequestStatus = BorrowRequest.RequestStatus
