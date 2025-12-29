import Foundation

final class UserManager {
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func viewProfile(userId: UUID) -> User? {
        
        userRepository.findById(userId)
    }

    private func updateProfile() {
       
    }
    
}
