import Foundation

final class InMemoryBorrowRequestRepository: BorrowRequestRepository {

    private var requests: [UUID: BorrowRequest] = [:]

    func save(_ request: BorrowRequest) {
        requests[request.requestId] = request
    }

    func findById(_ requestId: UUID) -> BorrowRequest? {
        requests[requestId]
    }

    func findAll() -> [BorrowRequest] {
        Array(requests.values)
    }

    func findPending() -> [BorrowRequest] {
        requests.values.filter { $0.status == .pending }.sorted {
            $0.requestDate < $1.requestDate
        }
    }

    func findByUserId(_ userId: UUID) -> [BorrowRequest] {
        requests.values.filter { $0.userId == userId }
    }
}
