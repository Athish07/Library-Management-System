import Foundation
struct BorrowRequest {
    let requestId: UUID
    let userId: UUID
    let bookId: UUID
    let requestDate: Date
    var status: RequestStatus
    
}

