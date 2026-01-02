import Foundation

protocol UserRepository {
    func save(_ user: User)
    func findById(_ userId: UUID) -> User?
    func findByEmail(_ email: String) -> User?
    func findAll() -> [User]

}
