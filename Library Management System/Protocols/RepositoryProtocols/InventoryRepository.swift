import Foundation

protocol InventoryRepository {
    func save(_ inventory: BookInventory)
    func findByBookId(_ bookId: UUID) -> BookInventory?
    func remove(bookId: UUID)
    func getAll() -> [BookInventory]
}
