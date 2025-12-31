import Foundation

enum AuthenticationError: Error, LocalizedError {

    case userNotFound
    case invalidPassword
    case userAlreadyExists

    var errorDescription: String? {
        switch self {
        case .userNotFound:
            return "No user found with this email."
        case .invalidPassword:
            return "Incorrect Password."
        case .userAlreadyExists:
            return "Account with this email already exists"
        }
    }
}

final class AuthenticationManager: AuthenticationService {

    private let userRepository: UserRepository

    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    func login(email: String, password: String) throws -> User {

        guard let user = userRepository.findByEmail(email) else {
            throw AuthenticationError.userNotFound
        }
        
        guard password == user.password else {
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
        
        let user = User(
            name: name,
            email: email,
            password: password,
            phoneNumber: phoneNumber,
            address: address,
            role: role
        )

        userRepository.save(user)
    }
    
}

