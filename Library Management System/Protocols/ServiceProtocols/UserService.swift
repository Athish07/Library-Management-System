import Foundation

protocol UserService {
    
    func getUserById(_ userId: UUID) -> User?
    func updateProfile(_ updatedUser: User) -> ProfileUpdateResult
    
}
