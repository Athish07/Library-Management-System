import Foundation

protocol BookRepository {
    func save(_ book: Book)
    func remove(bookId: UUID)
    func findById(_ bookId: UUID) -> Book?
    func getAllBooks() -> [Book]
}
