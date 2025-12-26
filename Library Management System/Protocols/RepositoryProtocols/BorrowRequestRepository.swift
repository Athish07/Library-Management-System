protocol BorrowRequestRepository {
    
    func save(_ request: BorrowRequest)
    func getPendingRequests() -> [BorrowRequest]
    
}
