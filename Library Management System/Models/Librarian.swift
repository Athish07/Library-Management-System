import Foundation

struct Librarian: Account {

    let id: UUID
    var name: String
    var email: String
    var password: String
    var phoneNumber: String
    var address: String

    init(
        id: UUID = UUID(),
        name: String,
        email: String,
        password: String,
        phoneNumber: String,
        address: String
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.password = password
        self.phoneNumber = phoneNumber
        self.address = address
    }

}
