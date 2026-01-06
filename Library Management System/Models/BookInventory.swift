import Foundation

struct BookInventory {
    
    let bookId: UUID
    private(set) var totalCopies: Int
    private(set) var availableCopies: Int

    init(bookId: UUID, totalCopies: Int) {
        self.bookId = bookId
        self.totalCopies = totalCopies
        self.availableCopies = totalCopies
    }

    mutating func addCopies(_ count: Int) {
        guard count > 0 else { return }
        totalCopies += count
        availableCopies += count
    }
    
    mutating func issueCopy() -> Bool {
        guard availableCopies > 0 else { return false }
        availableCopies -= 1
        return true
    }

    mutating func returnCopy() {
        guard availableCopies < totalCopies else { return }
        availableCopies += 1
    }
    
}
