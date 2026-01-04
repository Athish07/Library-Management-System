import Foundation

protocol BorrowRequestRepository {
    func save(_ request: BorrowRequest)
    func findById(_ requestId: UUID) -> BorrowRequest?
    func getByUserId(_ userId: UUID) -> [BorrowRequest]
    func getAllRequests() -> [BorrowRequest]
  
}
