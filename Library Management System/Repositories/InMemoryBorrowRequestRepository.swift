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
        requests.values
            .filter { $0.userId == userId }
            .sorted { $0.requestDate < $1.requestDate }
    }

    func getAllRequests() -> [BorrowRequest] {
        requests.values
            .sorted { $0.requestDate < $1.requestDate }
    }

}
