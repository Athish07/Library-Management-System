import Foundation

struct ProfileFlowHelper {

    static func handleProfileUpdate(
        userId: UUID,
        userService: UserService,
        view: ConsoleView
    ) {

        guard let user = userService.getUserById(userId) else {
            view.showError("User not found.")
            return
        }

        view.printUserDetails(user)

        let updatedUser = view.readUpdateUser(user)
        let result = userService.updateProfile(updatedUser)

        switch result {
        case .success:
            print("Profile updated successfully.")
        case .noChanges:
            view.showError("No changes detected.")
        case .userNotFound:
            view.showError("User not found.")
        }
    }
}

