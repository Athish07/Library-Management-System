import Foundation
final class InMemoryLibrarianRepository: LibrarianRepository {

    private let librarian: Librarian
    
    init(_ librarian: Librarian) {
        self.librarian = librarian
    }
    
    func getLibrarian() -> Librarian {
        librarian
    }
    
}

