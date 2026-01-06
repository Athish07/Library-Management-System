import Foundation

protocol BookInventoryRepository {
    func save(_ inventory: BookQuantity)
    func findByBookId(_ bookId: UUID) -> BookQuantity?
    func remove(bookId: UUID)
    func getAll() -> [BookQuantity]
}
