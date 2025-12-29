enum AuthenticationError: Error {

    case userNotFound
    case invalidPassword
    case userAlreadyExists

    var errorDescrxiption: String? {
        switch self {
        case .userNotFound:
            return "No user found with this email."
        case .invalidPassword:
            return "InCorrect Password."
        case .userAlreadyExists:
            return "Account with this email already exists"
        }
    }
}
