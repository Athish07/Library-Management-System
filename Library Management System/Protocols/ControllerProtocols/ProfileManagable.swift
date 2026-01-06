import Foundation

protocol ProfileManagable {
    var userId: UUID { get }
    var userService: UserService { get }
}

extension ProfileManagable {

    func viewProfile() {
        guard let user = userService.getUserById(userId) else {
            OutputUtils.showError("Unable to load profile.")
            return
        }
        OutputUtils.printUserDetails(user)
    }

    func updateProfile() {

        guard let user = userService.getUserById(userId) else {
            OutputUtils.showError("User not found.")
            return
        }

        OutputUtils.printUserDetails(user)

        print("\n press ENTER if you want to proceed with the same detail. \n")

        let name = InputUtils.readString(
            "Enter Name(current Name \(user.name))",
            allowEmpty: true
        )
        let email = InputUtils.readEmail(
            "Enter Email(current Email \(user.email))",
            allowEmpty: true
        )
        let phoneNumber = InputUtils.readPhoneNumber(
            "Enter PhoneNumber(current phoneNumber \(user.phoneNumber))",
            allowEmpty: true
        )
        let address = InputUtils.readString(
            "Enter Address(current Address \(user.address))",
            allowEmpty: true
        )

        let updatedUser = User(
            id: user.id,
            name: name,
            email: email,
            password: user.password,
            phoneNumber: phoneNumber,
            address: address,
            role: user.role
        )

        let result = userService.updateProfile(updatedUser)

        switch result {
        case .success:
            print("Profile updated successfully.")
        case .noChanges:
            print("No changes detected.")
        case .userNotFound:
            OutputUtils.showError("User not found.")
        }
    }

}
