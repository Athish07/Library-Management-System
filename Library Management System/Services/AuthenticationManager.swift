import Foundation

final class AuthenticationManager: AuthenticationService {

    private let userRepository: UserRepository
    private let librarianRepository: LibrarianRepository

    init(
        userRepository: UserRepository,
        librarianRepository: LibrarianRepository
    ) {
        self.userRepository = userRepository
        self.librarianRepository = librarianRepository
    }

    func login(email: String, password: String, role: UserRole) throws
        -> Account
    {

        switch role {

        case .user:
            guard let user = userRepository.findByEmail(email) else {
                throw AuthenticationError.userNotFound
            }

            guard password == user.password else {
                throw AuthenticationError.invalidPassword
            }
            return user

        case .librarian:
            guard let librarian = librarianRepository.findByEmail(email) else {
                throw AuthenticationError.userNotFound
            }

            guard password == librarian.password else {
                throw AuthenticationError.invalidPassword
            }
            return librarian
        }
        
    }

    func register(
        name: String,
        email: String,
        password: String,
        phoneNumber: String,
        address: String,
    ) throws {

        if userRepository.findByEmail(email) != nil {
            throw AuthenticationError.userAlreadyExists
        }

        let user = User(
            name: name,
            email: email,
            password: password,
            phoneNumber: phoneNumber,
            address: address
        )

        userRepository.save(user)
    }

}

extension AuthenticationManager {

    enum AuthenticationError: Error, LocalizedError {

        case userNotFound
        case invalidPassword
        case userAlreadyExists
        case unauthorizedAccess

        var errorDescription: String? {
            switch self {
            case .userNotFound:
                return "No user found with this email."
            case .invalidPassword:
                return "Incorrect Password."
            case .userAlreadyExists:
                return "Account with this email already exists"
            case .unauthorizedAccess:
                return "Unauthorized access."
            }
        }
    }

}
