import Foundation

protocol AuthenticationService {
    func loginUser(email: String, password: String) throws -> UUID
    func registerUser(
        userName: String,
        email: String,
        password: String,
        phoneNumber: String,
        address: String
    ) throws
    func loginLibrarian(_ email: String, _ password: String) throws -> UUID
}
