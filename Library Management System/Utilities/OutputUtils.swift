import Foundation

struct OutputUtils {

    static func showMenu<T: CaseIterable & RawRepresentable>(
        _ options: [T],
        title: String
    ) {

        print("\n=== \(title) ===\n")

        for (index, option) in options.enumerated() {
            print("\(index + 1). \(option.rawValue)")
        }

        print("")
    }

    static func showError(_ message: String) {
        print("\nERROR:\(message)\n")
    }

    static func printBookDetails(_ book: Book) {
        print(
            """
            Title: \(book.title)
            Author: \(book.author)
            Category: \(book.category.rawValue)
            """
        )
    }

    static func printBookQuantity(
        _ results: [(book: Book, inventory: BookQuantity)]
    ) {

        for (index, result) in results.enumerated() {
            print("\(index + 1).")
            printBookDetails(result.book)
            print(
                "Available : \(result.inventory.availableCopies)/\(result.inventory.totalCopies)\n"
            )
        }
    }
    
    static func printAccountDetails(_ user: User) {
        print(
            """
            User Details: 
            UserName: \(user.name) 
            Email: \(user.email)
            PhoneNumber: \(user.phoneNumber)
            Address: \(user.address)
            """
        )
    }

}
