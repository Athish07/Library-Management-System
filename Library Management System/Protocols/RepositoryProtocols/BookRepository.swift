import Foundation

protocol BookRepository {
    func save(_ book: Book)
    func remove(bookId: UUID)
    func findById(_ bookId: UUID) -> Book?
    func getAllBooks() -> [Book]
    func search(byTitle title: String) -> [Book]
    func search(byAuthor author: String) -> [Book]
    func search(byCategory category: BookCategory) -> [Book]
    func search(by query: String) -> [Book]
    func isAvailable(_ bookId: UUID) -> Bool
    func availableCount(for bookId: UUID) -> Int
}
