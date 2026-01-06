import Foundation

final class InMemoryUserRepository: UserRepository {

    private var users: [UUID: User] = [:]

    func save(_ user: User) {
        users[user.id] = user
    }

    func findById(_ userId: UUID) -> User? {
        users[userId]
    }

    func findByEmail(_ email: String) -> User? {
        users.values.first { $0.email == email }
    }

}
