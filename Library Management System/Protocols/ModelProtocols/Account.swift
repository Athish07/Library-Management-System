import Foundation

protocol Account {
    var id: UUID { get }
    var name: String { get set }
    var email: String { get set }
    var password: String { get set }
    var phoneNumber: String { get set }
    var address: String { get set }
    
}

enum UserRole: String, CaseIterable {
    
    case user = "User"
    case librarian = "Librarian"
}
