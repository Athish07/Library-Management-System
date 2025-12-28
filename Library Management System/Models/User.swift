import Foundation

struct User {

    let userId: UUID
    var name: String
    var email: String
    var password: String
    var phoneNumber: String
    var address: String
    let role: UserRole

    init(
        name: String,
        email: String,
        password: String,
        phoneNumber: String,
        address: String,
        role: UserRole
    ) {
        self.userId = UUID()
        self.name = name
        self.email = email
        self.password = password
        self.phoneNumber = phoneNumber
        self.address = address
        self.role = role
    }
    
}

