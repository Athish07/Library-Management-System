import Foundation

final class UserController: ProfileManagable {
    let userId: UUID
    let userService: UserService
    private let libraryService: LibraryService
    private let reportService: ReportService

    init(
        currentUserId: UUID,
        libraryService: LibraryService,
        userService: UserService,
        reportService: ReportService
    ) {
        self.userId = currentUserId
        self.libraryService = libraryService
        self.userService = userService
        self.reportService = reportService
    }

    func start() {

        while true {

            OutputUtils.showMenu(UserMenuOption.allCases, title: "USER MENU")

            guard
                let choice = InputUtils.readMenuChoice(
                    from: UserMenuOption.allCases,
                )
            else {
                OutputUtils.showError("Invalid choice")
                continue
            }

            switch choice {
            case .searchToBorrowBooks: searchBooks()
            case .viewAvailableBooks: viewAvailableBooks()
            case .viewMyBorrowedBooks: viewMyBorrowedBooks()
            case .renewBook: renewBook()
            case .returnBook: returnBook()
            case .borrowRequestHistory: borrowRequestHistory()
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

        let books = libraryService.search(by: query)

        if books.isEmpty {
            print(" No books found matching '\(query)'.")
            return

        } else {
            print(" Search Results (\(books.count) found):")

            for (index, book) in books.enumerated() {
                print("\(index + 1). ", terminator: "")
                OutputUtils.printBookDetails(book)
            }
        }

        requestBorrow(books)
    }

    private func viewAvailableBooks() {

        let books = libraryService.getAvailableBooks()

        if books.isEmpty {
            print(" No books are currently available.")
        } else {
            print(" Available Books (\(books.count)):")
            for (index, book) in books.enumerated() {
                print("\(index + 1). ", terminator: "")
                OutputUtils.printBookDetails(book)
            }
        }

        print(
            "\nDo you want to request to borrow any of these books? (y/n):",
            terminator: ""
        )

        let response = readLine()?.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).lowercased()

        guard response == "y" || response == "yes" else {
            print("Returning to menu...")
            return
        }

        requestBorrow(books)

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
                    OutputUtils.printBookDetails(book)
                    print("   Issued: \((issued.issueDate))")
                    print("   Due: \(issued.dueDate.formatted)")
                    if issued.isOverdue {
                        let days = issued.daysOverdue
                        print("OVERDUE by \(days) day(s)")
                    }
                    print(String(repeating: "===", count: 10))
                } catch {
                    OutputUtils.showError(error.localizedDescription)
                }
            }
        }

    }

    private func borrowRequestHistory() {

        let history = reportService.getBorrowRequestHistory(userId: userId)

        if history.isEmpty {
            print("No request history available.")
            return
        }

        for request in history {

            print(
                """
                Title : \(request.title)
                Author : \(request.author)
                Status : \(request.status)
                """
            )
        }
    }

    private func renewBook() {

        guard let selected = selectBorrowedBook() else {
            return
        }

        do {
            let updatedIssueBook = try libraryService.renewBook(
                selected.issueId
            )
            print(
                "Book renewed Successfully extended till \(updatedIssueBook.dueDate)"
            )
        } catch {
            OutputUtils.showError(error.localizedDescription)
        }

    }

    private func returnBook() {

        guard let selected = selectBorrowedBook() else {
            return
        }

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
            OutputUtils.showError(error.localizedDescription)
        }

    }
}

extension UserController {

    private func selectBorrowedBook() -> IssuedBook? {

        let borrowed = libraryService.getBorrowedBooks(for: userId)

        if borrowed.isEmpty {
            OutputUtils.showError("No book available.")
            return nil
        }
        print("Your Borrowed Books:")

        for (index, issued) in borrowed.enumerated() {
            do {
                let book = try libraryService.getBook(bookId: issued.bookId)

                print("\(index + 1). ", terminator: "")
                OutputUtils.printBookDetails(book)

                print(
                    " Due: \(issued.dueDate.formatted) \(issued.isOverdue ? "OVERDUE" : "")"
                )
            } catch {
                OutputUtils.showError(error.localizedDescription)
            }
        }

        guard
            let selectedBook = InputUtils.readMenuChoice(
                from: borrowed,
                prompt:
                    "Enter book number to request (or press ENTER to move back)"
            )
        else {
            return nil
        }

        return selectedBook

    }

    private func requestBorrow(_ books: [Book]) {

        guard
            let selectedBook = InputUtils.readMenuChoice(
                from: books,
                prompt:
                    "Enter book number to request (or press ENTER to move back)"
            )
        else {
            return
        }

        do {
            try libraryService.requestBorrow(
                bookId: selectedBook.bookId,
                by: userId
            )
            print(
                " Borrow request sent for '\(selectedBook.title)'!\nLibrarian will review it soon."
            )
        } catch {
            OutputUtils.showError(error.localizedDescription)
        }

    }

    enum UserMenuOption: String, CaseIterable {
        case searchToBorrowBooks = "Search to Borrow Books"
        case viewAvailableBooks = "View All Available Books and make borrow"
        case viewMyBorrowedBooks = "View My Borrowed Books"
        case renewBook = "Renew the Borrowed Book"
        case returnBook = "Return a Book"
        case borrowRequestHistory = "View BorrowRequest History"
        case viewProfile = "View Profile"
        case updateProfile = "Update Profile"
        case logout = "Logout"
    }

}
