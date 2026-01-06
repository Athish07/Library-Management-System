import Foundation

final class UserManager: UserService {

    private let userRepository: UserRepository

    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    func updateProfile(_ updatedUser: User) -> UpdateProfileResult {

        guard let existingUser = userRepository.findById(updatedUser.id)
        else {
            return .userNotFound
        }
        let mergedUser = User(
            id: existingUser.id,
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
