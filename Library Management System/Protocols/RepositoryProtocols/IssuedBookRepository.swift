import Foundation

protocol IssuedBookRepository {
    func save(_ issuedBook: IssuedBook)
    func findById(_ issueId: UUID) -> IssuedBook?
    func getAllIssuedBooks() -> [IssuedBook]
}
