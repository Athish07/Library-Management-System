import Foundation

struct BorrowRequest {
    let requestId: Int
    let userId: Int
    let bookId: Int
    let requestDate: Date
    var status: RequestStatus
    
}


