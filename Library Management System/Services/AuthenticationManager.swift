import CryptoKit
import Foundation

class AuthenticationManager: AuthenticationService {

    private let userRepository: UserRepository

    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    func login(email: String, password: String) throws -> UUID? {

        guard let user = userRepository.findByEmail(email) else {
            throw AuthenticationError.userNotFound
        }

        let hashedPassword = hash(password)

        guard hashedPassword == user.password else {
            throw AuthenticationError.invalidPassword
        }

        return user.userId

    }

    func registerUser(
        userName: String,
        email: String,
        password: String,
        phoneNumber: String,
        address: String
    ) throws {

        if userRepository.findByEmail(email) != nil {
            throw AuthenticationError.userAlreadyExists
        }

        let hashedPassword = hash(password)
        let userId = UUID()

        let user = User(
            userId: userId,
            userName: userName,
            email: email,
            password: hashedPassword,
            phoneNumber: phoneNumber,
            address: address
        )

        userRepository.save(user)

    }
    private func hash(_ password: String) -> String {
        let data = Data(password.utf8)
        let digest = SHA256.hash(data: data)
        return digest.map { String(format: "%02x", $0) }.joined()
    }
}
