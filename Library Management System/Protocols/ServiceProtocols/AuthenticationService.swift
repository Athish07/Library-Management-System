import Foundation

protocol AuthenticationService {
    func login(email: String, password: String, role: UserRole) throws -> User
    func register(
        name: String,
        email: String,
        password: String,
        phoneNumber: String,
        address: String
    ) throws
}

