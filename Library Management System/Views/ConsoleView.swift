import Foundation

final class ConsoleView {

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

    func waitForEnter() {
        print("Press Enter to continue...")
        _ = readLine()
    }
    
    func printBookDetails(_ book: Book) {
        print("\(book.title)")
        print("Author: \(book.author)")
        print("Category: \(book.category.rawValue)")
        print("Available: \(book.availableCopies)/\(book.totalCopies)")
        print("")
    }
    
}
