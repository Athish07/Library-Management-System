import Foundation

final class InMemoryLibrarianRepository: LibrarianRepository {
    
    private var librarians: [UUID: Librarian] = [:]
    
    func save(_ librarian: Librarian) {
        librarians[librarian.id] = librarian
    }
    
    func findById(_ id: UUID) -> Librarian? {
        librarians[id]
    }
    
    func findByEmail(_ email: String) -> Librarian? {
        librarians.values.first { $0.email == email }
    }
    
}

