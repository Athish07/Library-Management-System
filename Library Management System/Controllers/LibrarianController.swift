import Foundation

final class LibrarianController {

    private let userId: UUID
    private let libraryService: LibraryService
    private let userService: UserService
    private let consoleView = ConsoleView()

    init(
        currentUserId: UUID,
        libraryService: LibraryService,
        userService: UserService
    ) {
        self.userId = currentUserId
        self.libraryService = libraryService
        self.userService = userService
    }

    func start() {
        print("Librarian Mode")

        while true {
            consoleView.showMenu(
                LibrarianMenuOption.allCases,
                title: "LIBRARIAN MENU"
            )

            guard
                let choice = InputUtils.readMenuChoice(
                    from: LibrarianMenuOption.allCases
                )
            else {
                consoleView.showError("Invalid choice")
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

        print("Available categories:")
        for category in BookCategory.allCases {
            print("  • \(category.rawValue.capitalized)")
        }

        let categoryInput = InputUtils.readString("Enter category")
        guard let category = BookCategory(rawValue: categoryInput.lowercased())
        else {
            consoleView.showError("Invalid category")
            return
        }

        let copies = InputUtils.readInt("Enter number of copies", allowCancel: false) ?? 0
        guard copies > 0 else {
            consoleView.showError("Number of copies must be greater than 0")
            return
        }

        do {
            try libraryService.addBook(
                title: title,
                author: author,
                category: category,
                totalCopies: copies
            )
            print("Book '\(title)' added successfully with \(copies) copies!")
        } catch {
            consoleView.showError(
                "Failed to add book: \(error.localizedDescription)"
            )
        }
    }

    private func removeBook() {
        let books = libraryService.getAllBooks()

        if books.isEmpty {
            print("No books in the library.")
            return
        }
        print("All books in the library:")

        for book in books {
            consoleView.printBookDetails(book)
        }

        let index = InputUtils.readInt(
            "Enter book number to remove (or press Enter to cancel)",
            allowCancel: true
        )
        guard let idx = index, idx >= 1 && idx <= books.count else {
            print("Remove cancelled.")
            return
        }

        let book = books[idx - 1]

        do {
            try libraryService.removeBook(bookId: book.bookId)
            print("Book '\(book.title)' removed successfully.")
        } catch {
            consoleView.showError(
                "Failed to remove book: \(error.localizedDescription)"
            )
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
                consoleView.printBookDetails(book)

                print("Request Date: \(formatDate(request.requestDate))")
                print("Requested By: \(userService.getUserById(userId)?.name ?? "Unknown")")
                print("---")
            } catch {
                print(
                    "\(index + 1). Request ID: \(request.requestId.uuidString.prefix(8)) (Book not found)"
                )
            }
        }

        let choice = InputUtils.readInt(
            "Enter request number to manage (or press Enter to go back)",
            allowCancel: true
        )
        
        guard let idx = choice, idx >= 1 && idx <= requests.count else {
            return
        }

        let selected = requests[idx - 1]
        consoleView.showMenu(
            BorrowRequestAction.allCases,
            title: "Manage Borrow Request"
        )
        print(
            "Manage Request for Book ID: \(selected.bookId.uuidString.prefix(8))"
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
                    showBorrowedBook(book, issuedBook)
                } catch {
                    print(
                        "Issued Book ID: \(issuedBook.issueId.uuidString.prefix(8)) (Book missing)"
                    )
                }
            }
        }
    }

    private func viewProfile() {

        guard let user = userService.getUserById(userId) else {
            return
        }

        consoleView.printUserDetails(user)
    }

    private func updateProfile() {
       ProfileFlowHelper.handleProfileUpdate(
            userId: userId,
            userService: userService,
               view: consoleView
           )
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

extension LibrarianController {

    // I am using this only in the libraryController

    func showBorrowedBook(_ book: Book, _ issued: IssuedBook) {
        print(
            """
            Issued Book Details : 
            Book Title: \(book.title)
            Book Author: \(book.author)
            Book Category: \(book.category)
            Issued Date : \(issued.issueDate)
            Due Date: \(issued.dueDate)
            Days OverDued: \(issued.daysOverdue)
            """
        )
    }
}
