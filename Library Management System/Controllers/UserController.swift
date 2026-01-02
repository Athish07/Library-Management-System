import Foundation

final class UserController: ProfileManagable {
    let userId: UUID
    let userService: UserService
    let consolePrinter: ConsolePrinter
    private let libraryService: LibraryService

    init(
        currentUserId: UUID,
        libraryService: LibraryService,
        userService: UserService,
        consolePrinter: ConsolePrinter
    ) {
        self.userId = currentUserId
        self.libraryService = libraryService
        self.userService = userService
        self.consolePrinter = consolePrinter
    }

    func start() {

        while true {

            consolePrinter.showMenu(UserMenuOption.allCases, title: "USER MENU")

            guard
                let choice = InputUtils.readMenuChoice(
                    from: UserMenuOption.allCases,
                )
            else {
                consolePrinter.showError("Invalid choice")
                continue
            }

            switch choice {
            case .searchBooks: searchBooks()
            case .viewAvailableBooks: viewAvailableBooks()
            case .viewMyBorrowedBooks: viewMyBorrowedBooks()
            case .requestBorrow: requestBorrowBook()
            case .returnBook: returnBook()
            case .viewProfile: viewProfile()
            case .updateProfile: updateProfile()
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

        let results = libraryService.search(by: query)

        if results.isEmpty {
            print(" No books found matching '\(query)'.")
        } else {
            print(" Search Results (\(results.count) found):")
            for book in results {
                consolePrinter.printBookDetails(book)
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
                consolePrinter.printBookDetails(book)
            }
        }
    }

    private func viewMyBorrowedBooks() {

        let borrowed = libraryService.getBorrowedBooks(for: userId)

        if borrowed.isEmpty {
            print("You have no borrowed books.")
        } else {
            print("Your Borrowed Books (\(borrowed.count)):")

            for issued in borrowed {
                do {
                    let book = try libraryService.getBook(bookId: issued.bookId)
                    consolePrinter.printBookDetails(book)
                    print("   Issued: \((issued.issueDate))")
                    print("   Due: \(issued.dueDate.formattedMediumDateTime)")
                    if issued.isOverdue {
                        let days = issued.daysOverdue
                        print("OVERDUE by \(days) day(s)")
                    }
                    print(String(repeating: "===", count: 10))
                } catch {
                    consolePrinter.showError(error.localizedDescription)
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
            consolePrinter.printBookDetails(book)
        }

        guard
            let index = InputUtils.readInt(
                "Enter book number to request (or press Enter to cancel)",
                allowCancel: true
            ), (1...books.count).contains(index)
        else {
            print("Borrow request cancelled.")
            return
        }

        let selectedBook = books[index - 1]

        do {
            try libraryService.requestBorrow(
                bookId: selectedBook.bookId,
                by: userId
            )
            print(
                " Borrow request sent for '\(selectedBook.title)'!\nLibrarian will review it soon."
            )
        } catch {
            consolePrinter.showError(error.localizedDescription)
        }
    }

    private func returnBook() {

        let borrowed = libraryService.getBorrowedBooks(for: userId)

        if borrowed.isEmpty {
            print("You have no books to return.")
            return
        }

        print("Your Borrowed Books:")

        for (index, issued) in borrowed.enumerated() {
            do {
                let book = try libraryService.getBook(bookId: issued.bookId)

                print("\(index + 1). ", terminator: "")
                consolePrinter.printBookDetails(book)

                print(
                    " Due: \(issued.dueDate.formattedMediumDateTime) \(issued.isOverdue ? "OVERDUE" : "")"
                )
            } catch {
                consolePrinter.showError(error.localizedDescription)
            }
        }

        guard
            let index = InputUtils.readInt(
                "Enter book number to return (press ENTER to cancel operation)",
                allowCancel: true
            ), (1...borrowed.count).contains(index)
        else {
            print("Return cancelled.")
            return
        }
        let selected = borrowed[index - 1]

        do {
            let fine = try libraryService.returnBook(
                issueId: selected.issueId,
                on: Date()
            )
            if fine > 0 {
                print(
                    "Book returned successfully!\n You have a fine of \(fine) for being overdue."
                )
            } else {
                print("Book returned successfully! No fine. Thank you!")
            }
        } catch {
            consolePrinter.showError(error.localizedDescription)
        }

    }
}

extension UserController {

    enum UserMenuOption: String, CaseIterable {
        case searchBooks = "Search Books"
        case viewAvailableBooks = "View All Available Books"
        case viewMyBorrowedBooks = "View My Borrowed Books"
        case requestBorrow = "Request to Borrow a Book"
        case returnBook = "Return a Book"
        case viewProfile = "View Profile"
        case updateProfile = "Update Profile"
        case logout = "Logout"
    }

}
