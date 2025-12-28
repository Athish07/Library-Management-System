import Foundation

protocol BorrowRequestRepository {
    func save(_ request: BorrowRequest)
    func findById(_ requestId: UUID) -> BorrowRequest?
    func findAll() -> [BorrowRequest]
    func findPending() -> [BorrowRequest]
    func findByUserId(_ userId: UUID) -> [BorrowRequest]
}

