import Foundation
 
enum UpdateProfileResult {
    case success
    case noChanges
    case userNotFound
}

protocol UserService {
    func getUserById(_ userId: UUID) -> User?
    func updateProfile(_ updatedUser: User) -> UpdateProfileResult
}
