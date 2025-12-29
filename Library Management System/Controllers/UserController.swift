import Foundation

final class UserController {
    
    private let currentUser: User
    private let libraryService: LibraryService
    private let consoleView = ConsoleView()
    
    init(currentUser: User, libraryService: LibraryService) {
        self.currentUser = currentUser
        self.libraryService = libraryService
    }
    
    func start() {
        print("Welcome to the Library, \(currentUser.name)!")
        
        while true {
            consoleView.showMenu(UserMenuOption.allCases, title: "USER MENU")
            
            guard
                let choice = InputUtils.readMenuChoice(
                    from: UserMenuOption.allCases
                )
            else {
                consoleView.showError("Invalid choice")
                continue
            }
            
            switch choice {
            case .searchBooks: searchBooks()
            case .viewAvailableBooks: viewAvailableBooks()
            case .viewMyBorrowedBooks: viewMyBorrowedBooks()
            case .requestBorrow: requestBorrowBook()
            case .returnBook: returnBook()
            case .logout:
                print("You have been logged out successfully.")
                return
            }
        }
    }
    
    private func searchBooks() {
        
        let query = InputUtils.readString(
            "Enter search term (title/author/category)"
        )
        
        let results = libraryService.searchBooks(by: query)
        
        if results.isEmpty {
            print(" No books found matching '\(query)'.")
        } else {
            print(" Search Results (\(results.count) found):")
            for book in results {
                consoleView.printBookDetails(book)
            }
        }
    }
    
    private func viewAvailableBooks() {
        
        let books = libraryService.getAvailableBooks()
        
        if books.isEmpty {
            print(" No books are currently available.")
        } else {
            print(" Available Books (\(books.count)):")
            for book in books {
                consoleView.printBookDetails(book)
            }
        }
    }
    
    private func viewMyBorrowedBooks() {
        
        let borrowed = libraryService.getBorrowedBooks(for: currentUser.userId)
        
        if borrowed.isEmpty {
            print("You have no borrowed books.")
        } else {
            print("Your Borrowed Books (\(borrowed.count)):")
            
            for issued in borrowed {
                do {
                    let book = try libraryService.getBook(bookId: issued.bookId)
                    consoleView.printBookDetails(book)
                    print("   Issued: \(formatDate(issued.issueDate))")
                    print("   Due: \(formatDate(issued.dueDate))")
                    if issued.isOverdue {
                        let days = issued.daysOverdue
                        print("OVERDUE by \(days) day(s) - Fine: $\(days).00")
                    }
                    print(
                        "Issue ID: \(issued.issueId.uuidString.prefix(8))...\n"
                    )
                    print("---")
                } catch {
                    consoleView.showError(
                        "Could not load book details for issue \(issued.issueId.uuidString.prefix(8))"
                    )
                }
            }
        }
        
    }
    
    private func requestBorrowBook() {
        let books = libraryService.getAvailableBooks()
        
        if books.isEmpty {
            print("No books available to borrow right now.")
            return
        }
        
        print("Available Books to Borrow:")
        for (index, book) in books.enumerated() {
            print("\(index + 1). ", terminator: "")
            consoleView.printBookDetails(book)
        }
        
        guard
            let index = InputUtils.readInt(
                "Enter book number to request (or press Enter to cancel)",
                allowCancel: true
            ),
            index >= 1 && index <= books.count
        else {
            print("Borrow request cancelled.")
            return
        }
        
        let selectedBook = books[index - 1]
        
        do {
            try libraryService.requestBorrow(
                bookId: selectedBook.bookId,
                by: currentUser.userId
            )
            print(
                " Borrow request sent for '\(selectedBook.title)'!\nLibrarian will review it soon."
            )
        } catch {
            consoleView.showError(
                "Failed to send request: \(error.localizedDescription)"
            )
        }
    }
    
    private func returnBook() {
        let borrowed = libraryService.getBorrowedBooks(for: currentUser.userId)
        
        if borrowed.isEmpty {
            print("You have no books to return.")
            return
        }
        
        print("Your Borrowed Books:")
        for (index, issued) in borrowed.enumerated() {
            do {
                let book = try libraryService.getBook(bookId: issued.bookId)
                    print("\(index + 1). ", terminator: "")
                    consoleView.printBookDetails(book)
                    print(
                        " Due: \(formatDate(issued.dueDate)) \(issued.isOverdue ? "OVERDUE" : "")"
                    )
            }catch {
                consoleView.showError(
                    "Could not load book details for issue \(issued.issueId.uuidString.prefix(8))"
                )
            }
            
            guard
                let index = InputUtils.readInt(
                    "Enter book number to return",
                    allowCancel: true
                ),
                index >= 1 && index <= borrowed.count
            else {
                print("Return cancelled.")
                return
            }
            
            let selected = borrowed[index - 1]
            
            do {
                let fine = try libraryService.returnBook(
                    issueId: selected.issueId
                )
                if fine > 0 {
                    print(
                        "Book returned successfully!\n You have a fine of \(fine) for being overdue."
                    )
                } else {
                    print("Book returned successfully! No fine. Thank you!")
                }
            } catch {
                consoleView.showError(
                    "Return failed: \(error.localizedDescription)"
                )
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
}



