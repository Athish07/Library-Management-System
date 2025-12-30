import Foundation

final class UserManager: UserService {

    private let userRepository: UserRepository

    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    func updateProfile(_ updatedUser: User) -> ProfileUpdateResult {

        guard let existingUser = userRepository.findById(updatedUser.userId)
        else {
            return .userNotFound
        }
        
        let mergedUser = User(
            userId: existingUser.userId,
            name: updatedUser.name.isEmpty
                ? existingUser.name
                : updatedUser.name,

            email: updatedUser.email.isEmpty
                ? existingUser.email
                : updatedUser.email,

            password: updatedUser.password.isEmpty
                ? existingUser.password
                : updatedUser.password,

            phoneNumber: updatedUser.phoneNumber.isEmpty
                ? existingUser.phoneNumber
                : updatedUser.phoneNumber,

            address: updatedUser.address.isEmpty
                ? existingUser.address
                : updatedUser.address,

            role: existingUser.role
        )

        guard mergedUser != existingUser else {
            return .noChanges
        }
        
        userRepository.save(mergedUser)
        return .success
    }


    func getUserById(_ userId: UUID) -> User? {
        userRepository.findById(userId)
    }
}

extension UserManager {
    
   enum ProfileUpdateResult {
        case success
        case noChanges
        case userNotFound
    }
    
}
