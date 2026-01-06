import Foundation

final class InMemoryBookInventoryRepository: BookInventoryRepository {

    private var inventories: [UUID: BookQuantity] = [:]

    func save(_ inventory: BookQuantity) {
        inventories[inventory.bookId] = inventory
    }

    func findByBookId(_ bookId: UUID) -> BookQuantity? {
        inventories[bookId]
    }

    func remove(bookId: UUID) {
        inventories.removeValue(forKey: bookId)
    }

    func getAll() -> [BookQuantity] {
        Array(inventories.values)
    }
    
}
