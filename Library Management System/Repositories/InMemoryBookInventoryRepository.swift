import Foundation

final class InMemoryBookInventoryRepository: BookInventoryRepository {

    private var inventories: [UUID: BookInventory] = [:]

    func save(_ inventory: BookInventory) {
        inventories[inventory.bookId] = inventory
    }

    func findByBookId(_ bookId: UUID) -> BookInventory? {
        inventories[bookId]
    }

    func remove(bookId: UUID) {
        inventories.removeValue(forKey: bookId)
    }

    func getAll() -> [BookInventory] {
        Array(inventories.values)
    }
    
}
