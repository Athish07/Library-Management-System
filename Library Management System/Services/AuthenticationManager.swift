import CryptoKit
import Foundation

final class AuthenticationManager: AuthenticationService {

    private let userRepository: UserRepository

    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    func login(email: String, password: String) throws -> User {

        guard let user = userRepository.findByEmail(email) else {
            throw AuthenticationError.userNotFound
        }

        let hashedPassword = hash(password)

        guard hashedPassword == user.password else {
            throw AuthenticationError.invalidPassword
        }

        return user
    }

    func register(
        name: String,
        email: String,
        password: String,
        phoneNumber: String,
        address: String,
        role: UserRole
    ) throws {

        if userRepository.findByEmail(email) != nil {
            throw AuthenticationError.userAlreadyExists
        }

        let hashedPassword = hash(password)

        let user = User(
            name: name,
            email: email,
            password: hashedPassword,
            phoneNumber: phoneNumber,
            address: address,
            role: role
        )

        userRepository.save(user)
    }

    private func hash(_ password: String) -> String {
        let data = Data(password.utf8)
        let digest = SHA256.hash(data: data)
        return digest.map { String(format: "%02x", $0) }.joined()
    }
}

extension AuthenticationManager {

    func seedDemoDetails(userRepository: any UserRepository) {

        if userRepository.findByEmail("athish@gmail.com") == nil {
            let hashed = hash("Athish_07")

            let librarian = User(
                name: "Head Librarian",
                email: "athish@gmail.com",
                password: hashed,
                phoneNumber: "8148847642",
                address: "Main Library Building",
                role: .librarian
            )

            userRepository.save(librarian)
        }

        if userRepository.findByEmail("user@gamil.com") == nil {
            let hashed = hash("Athish_07")

            let testUser = User(
                name: "Test User",
                email: "user@gmail.com",
                password: hashed,
                phoneNumber: "7904411578",
                address: "123 Test Street",
                role: .user
            )
            userRepository.save(testUser)
        }
    }
}
