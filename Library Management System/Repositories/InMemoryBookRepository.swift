import Foundation

final class InMemoryBookRepository: BookRepository {
    
    private var books: [UUID: Book] = [:]
    
    func save(_ book: Book) {
        books[book.id] = book
    }

    func remove(bookId: UUID) {
        books.removeValue(forKey: bookId)
    }

    func findById(_ bookId: UUID) -> Book? {
        books[bookId]
    }

    func getAllBooks() -> [Book] {
        Array(books.values).sorted {
            $0.title.lowercased() < $1.title.lowercased()
        }
    }
    
}
