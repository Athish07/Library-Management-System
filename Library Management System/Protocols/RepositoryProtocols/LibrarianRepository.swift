import Foundation

protocol LibrarianRepository {
    func save(_ librarian: Librarian)
    func findById(_ id: UUID) -> Librarian?
    func findByEmail(_ email: String) -> Librarian?
    
}

