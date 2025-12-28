import Foundation

protocol IssuedBookRepository {
    func save(_ issuedBook: IssuedBook)
    func findById(_ issueId: UUID) -> IssuedBook?
    func findByUserId(_ userId: UUID) -> [IssuedBook]
    func findAll() -> [IssuedBook]
}

