import Foundation

final class InMemoryBookRepository: BookRepository {
    private var books: [UUID: Book] = [:]
    
    func save(_ book: Book) {
        books[book.bookId] = book
    }
    
    func remove(bookId: UUID) {
        books.removeValue(forKey: bookId)
    }
    
    func findById(_ bookId: UUID) -> Book? {
        books[bookId]
    }
    
    func getAllBooks() -> [Book] {
        Array(books.values).sorted { $0.title.lowercased() < $1.title.lowercased() }
    }
    
    func search(byTitle title: String) -> [Book] {
        books.values.filter { $0.title.lowercased().contains(title.lowercased()) }
    }
    
    func search(byAuthor author: String) -> [Book] {
        books.values.filter { $0.author.lowercased().contains(author.lowercased()) }
    }
    
    func search(byCategory category: BookCategory) -> [Book] {
        books.values.filter { $0.category == category }
    }
    
    func isAvailable(_ bookId: UUID) -> Bool {
        books[bookId]?.availableCopies ?? 0 > 0
    }
    
    func availableCount(for bookId: UUID) -> Int {
        books[bookId]?.availableCopies ?? 0
    }
}
