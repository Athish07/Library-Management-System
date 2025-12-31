import Foundation

struct ProfileUpdateFlow {

    static func handleProfileUpdate(
        userId: UUID,
        userService: UserService,
        consolePrinter: ConsolePrinter
    ) {

        guard let user = userService.getUserById(userId) else {
            consolePrinter.showError("User not found.")
            return
        }

        consolePrinter.printUserDetails(user)

        let updatedUser = consolePrinter.readUpdateUser(user)
        let result = userService.updateProfile(updatedUser)

        switch result {
        case .success:
            print("Profile updated successfully.")
        case .noChanges:
            consolePrinter.showError("No changes detected.")
        case .userNotFound:
            consolePrinter.showError("User not found.")
        }
    }
}

