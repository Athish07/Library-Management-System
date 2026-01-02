import Foundation

protocol ProfileManagable {
    var userId: UUID { get }
    var userService: UserService { get }
    var consolePrinter: ConsolePrinter { get }
}

extension ProfileManagable {

    func viewProfile() {
        guard let user = userService.getUserById(userId) else {
            consolePrinter.showError("Unable to load profile.")
            return
        }
        consolePrinter.printUserDetails(user)
    }

    func updateProfile() {

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
