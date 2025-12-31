import Foundation

final class InMemoryBorrowRequestRepository: BorrowRequestRepository {
    
    private var requests: [UUID: BorrowRequest] = [:]
    
    func save(_ request: BorrowRequest) {
        requests[request.requestId] = request
    }
    
    func findById(_ requestId: UUID) -> BorrowRequest? {
        requests[requestId]
    }
    
    func getAllRequests() -> [BorrowRequest] {
        Array(requests.values)
            .sorted { $0.requestDate < $1.requestDate }
    }

    
}
