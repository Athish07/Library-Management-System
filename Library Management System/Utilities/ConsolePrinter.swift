import Foundation

final class ConsolePrinter {

    func showMenu<T: CaseIterable & RawRepresentable>(
        _ options: [T],
        title: String
    ) {
        
        print("=== \(title) ===\n")

        for (index, option) in options.enumerated() {
            print("\(index + 1). \(option.rawValue)")
        }
    }

    func showError(_ message: String) {
        print("\nERROR:\(message)\n")
    }
    
    
    func printBookDetails(_ book: Book) {
        print("\(book.title)")
        print("Author: \(book.author)")
        print("Category: \(book.category.rawValue)")
        print("Available: \(book.availableCopies)/\(book.totalCopies)")
        print(String(repeating:"==",count: 10))
    }

    func printUserDetails(_ user: User) {
        print("UserName: \(user.name)")
        print("Email: \(user.email)")
        print("Address: \(user.address)")
        print("Role: \(user.role.rawValue)")
    }

    func readUpdateUser(_ user: User) -> User {

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

        return User(
            userId: user.userId,
            name: name,
            email: email,
            password: user.password,
            phoneNumber: phoneNumber,
            address: address,
            role: user.role
        )

    }

}
