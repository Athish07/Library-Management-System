import Foundation

final class InMemoryBorrowRequestRepository: BorrowRequestRepository {
    
    private var requests: [UUID: BorrowRequest] = [:]
    
    func save(_ request: BorrowRequest) {
        requests[request.requestId] = request
    }
    
    func getPendingRequests() -> [BorrowRequest] {
        requests.values.filter{ $0.status == .pending }
    }
    
}

