import Foundation

final class LibrarianController: ProfileManagable {

    let userId: UUID
    let userService: UserService
    let consolePrinter: ConsolePrinter
    private let libraryService: LibraryService
    private let reportService: ReportService

    init(
        currentUserId: UUID,
        libraryService: LibraryService,
        userService: UserService,
        reportService: ReportService,
        consolePrinter: ConsolePrinter
    ) {
        self.userId = currentUserId
        self.libraryService = libraryService
        self.userService = userService
        self.reportService = reportService
        self.consolePrinter = consolePrinter
    }

    func start() {

        while true {
            consolePrinter.showMenu(
                LibrarianMenu.allCases,
                title: "LIBRARIAN MENU"
            )

            guard
                let choice = InputUtils.readMenuChoice(
                    from: LibrarianMenu.allCases
                )
            else {
                consolePrinter.showError("Invalid choice")
                continue
            }

            switch choice {
            case .addBook:
                addBook()
            case .removeBook:
                removeBook()
            case .viewPendingRequests:
                viewAndManagePendingRequests()
            case .viewAllIssuedBooks:
                viewAllIssuedBooks()
            case .viewIssuedBookHistory: viewIssuedBookHistory()
            case .viewOverdueBooks: viewOverdueBooks()
            case .viewProfile: viewProfile()
            case .updateProfile: updateProfile()
            case .logout:
                print("You have been logged out from Librarian mode.")
                return
            }
        }
    }

    private func addBook() {

        print("=== Add New Book ===")

        let title = InputUtils.readString("Enter book title")
        let author = InputUtils.readString("Enter author name")

        consolePrinter
            .showMenu(BookCategory.allCases, title: "Available categories.")

        guard
            let category = InputUtils.readMenuChoice(
                from: BookCategory.allCases,
                prompt: "Enter your choice(press ENTER to move back)"
            )
        else {
            return
        }

        guard
            let copies = InputUtils.readInt(
                "Enter number of copies",
                allowCancel: false
            ), copies > 0
        else {
            consolePrinter.showError("Number of copies must be greater than 0")
            return
        }

        do {
            try libraryService.addBook(
                title: title,
                author: author,
                category: category,
                copiesToAdd: copies
            )
            print("Book '\(title)' added successfully with \(copies) copies!")
        } catch {
            consolePrinter.showError(error.localizedDescription)
        }
    }

    private func removeBook() {
        let books = libraryService.getAllBooks()

        if books.isEmpty {
            print("No books in the library.")
            return
        }
        print("All books in the library:")

        for (index, book) in books.enumerated() {
            print("\(index + 1).", terminator: "")
            consolePrinter.printBookDetails(book)
        }

        guard
            let index = InputUtils.readInt(
                "Enter book number to remove (or press Enter to cancel)",
                allowCancel: true
            ), (1...books.count).contains(index)
        else {
            print("Remove cancelled.")
            return
        }

        let book = books[index - 1]

        do {
            try libraryService.removeBook(bookId: book.bookId)
            print("Book '\(book.title)' removed successfully.")
        } catch {
            consolePrinter.showError(error.localizedDescription)
        }
    }

    private func viewAndManagePendingRequests() {

        let requests = libraryService.getAllPendingRequests()

        if requests.isEmpty {
            print("No pending borrow requests.")
            return
        }

        print("Pending Borrow Requests (\(requests.count)):")

        for (index, request) in requests.enumerated() {
            do {
                let book = try libraryService.getBook(bookId: request.bookId)

                print("\(index + 1).")
                consolePrinter.printBookDetails(book)

                print(
                    "Request Date: \(request.requestDate.formatted)"
                )
                print(
                    "Requested By: \(userService.getUserById(request.userId)?.name ?? "Unknown")"
                )
                print("---")
            } catch {
                consolePrinter.showError(error.localizedDescription)
            }
        }

        guard
            let choice = InputUtils.readInt(
                "Enter request number to manage (or press Enter to go back)",
                allowCancel: true
            )
        else {
            return
        }

        let selected = requests[choice - 1]

        consolePrinter.showMenu(
            BorrowRequestAction.allCases,
            title: "Manage Borrow Request"
        )

        guard
            let action = InputUtils.readMenuChoice(
                from: BorrowRequestAction.allCases,
                prompt: "Enter your Choice(press ENTER to move back)"
            )
        else {
            return
        }

        do {
            switch action {
            case .issue:
                try libraryService.approveBorrowRequest(
                    requestId: selected.requestId
                )
                print("Request approved and book issued.")
            case .reject:
                try libraryService.rejectBorrowRequest(
                    requestId: selected.requestId
                )
                print("Request rejected.")

            }
        } catch {
            print(error.localizedDescription)
        }

    }

    private func viewIssuedBookHistory() {
        let books = libraryService.getAllBooks()

        guard !books.isEmpty else {
            print("No books available.")
            return
        }

        for (index, book) in books.enumerated() {
            print("\(index + 1). \(book.title)")
        }

        guard
            let index = InputUtils.readInt(
                "Select book number (Press Enter to cancel)",
                allowCancel: true
            ), (1...books.count).contains(index)
        else { return }

        do {
            let history = try reportService.getIssuedBookHistory(
                bookId: books[index - 1].bookId
            )

            if history.isEmpty {
                print("No history found for this book.")
                return
            }

            for record in history {
                print(
                    """
                    Book: \(record.bookTitle)
                    Author: \(record.author)
                    Borrowed By: \(record.userName)
                    Email: \(record.email)
                    ---
                    """
                )
            }
        } catch {
            consolePrinter.showError(error.localizedDescription)
        }
    }

    private func viewOverdueBooks() {
        let overdue = reportService.getOverdueBooks()

        guard !overdue.isEmpty else {
            print("No overdue books.")
            return
        }

        for item in overdue {
            print(
                """
                Book: \(item.bookTitle)
                Author: \(item.author)
                User: \(item.userName)
                Days Overdue: \(item.daysOverdue)
                ---
                """
            )
        }
    }

    private func viewAllIssuedBooks() {
        let issued = libraryService.getAllIssuedBooks()

        if issued.isEmpty {
            print("No books currently issued.")
        } else {
            print(" All Issued Books (\(issued.count)):")
            for issuedBook in issued {
                do {
                    let book = try libraryService.getBook(
                        bookId: issuedBook.bookId
                    )
                    print(
                        """
                        Issued Book Details :
                        Book Title: \(book.title)
                        Book Author: \(book.author)
                        Book Category: \(book.category)
                        Issued Date : \(issuedBook.issueDate)
                        Due Date: \(issuedBook.dueDate)
                        Days OverDued: \(issuedBook.daysOverdue)
                        """
                    )

                } catch {
                    consolePrinter.showError(error.localizedDescription)
                }
            }
        }
    }
}

extension LibrarianController {

    enum LibrarianMenu: String, CaseIterable {
        case addBook = "Add New Book"
        case removeBook = "Remove Book"
        case viewPendingRequests = "View Pending Borrow Requests"
        case viewAllIssuedBooks = "View All Issued Books"
        case viewIssuedBookHistory = "View Issued Book History"
        case viewOverdueBooks = "View Over-Dued Books"
        case viewProfile = "View Profile"
        case updateProfile = "Update Profile"
        case logout = "Logout"
    }

    enum BorrowRequestAction: String, CaseIterable {
        case issue = "Issue"
        case reject = "Reject"
    }

}
