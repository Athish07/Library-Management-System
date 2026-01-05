import Foundation

struct User: Equatable {
    
    let userId: UUID
    var name: String
    var email: String
    var password: String
    var phoneNumber: String
    var address: String
    let role: Role

    enum Role: String, CaseIterable {
        case user = "User"
        case librarian = "Librarian"

    }

    init(
        userId: UUID = UUID(),
        name: String,
        email: String,
        password: String,
        phoneNumber: String,
        address: String,
        role: Role
    ) {
        self.userId = userId
        self.name = name
        self.email = email
        self.password = password
        self.phoneNumber = phoneNumber
        self.address = address
        self.role = role
    }

}
typealias UserRole = User.Role
