import Foundation

protocol IssuedBookRepository {
    func save(_ issuedBook: IssuedBook)
    func getIssuedBooks(_ userId: UUID) -> [IssuedBook]
    
}
