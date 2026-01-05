import Foundation

final class InMemoryBorrowRequestRepository: BorrowRequestRepository {

    private var requests: [UUID: BorrowRequest] = [:]

    func save(_ request: BorrowRequest) {
        requests[request.requestId] = request
    }

    func findById(_ requestId: UUID) -> BorrowRequest? {
        requests[requestId]
    }

    func getByUserId(_ userId: UUID) -> [BorrowRequest] {
        Array(requests.values).filter {
            $0.userId == userId
        }
    }

    func getAllRequests() -> [BorrowRequest] {
        Array(requests.values)
            .sorted { $0.requestDate < $1.requestDate }
    }

}
