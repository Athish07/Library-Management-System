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

        print("")
    }

    func showError(_ message: String) {
        print("\nERROR:\(message)\n")
    }

    func printBookDetails(_ book: Book) {
        print(
            """
            Title: \(book.title)
            Author: \(book.author)
            Category: \(book.category.rawValue)
            Available: \(book.availableCopies)/\(book.totalCopies)
            """
        )
        print(String(repeating: "==", count: 10))
    }

    func printUserDetails(_ user: User) {
        print(
            """
            User Details: 
            UserName: \(user.name) 
            Email: \(user.email)
            Address: \(user.address)
            Role: \(user.role.rawValue)
            """
        )
    }
    
}
