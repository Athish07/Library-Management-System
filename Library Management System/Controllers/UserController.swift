import Foundation

final class UserController: ProfileManagable {
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
                    print("   Due: \(issued.dueDate.formatted)")
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
            let index = InputUtils.readValidIndex(
                from: books.count,
                prompt:
                    "Enter book number to request (or press Enter to cancel)"
            )
        else {
            return
        }

        let selectedBook = books[index]

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
            consolePrinter.showError(error.localizedDescription)
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
            consolePrinter.showError(error.localizedDescription)
        }

    }
}

extension UserController {
    
    private func selectBorrowedBook() -> IssuedBook? {
        
        let borrowed = libraryService.getBorrowedBooks(for: userId)
        
        if borrowed.isEmpty {
            consolePrinter.showError("No book available.")
        }
        print("Your Borrowed Books:")
        
        for (index, issued) in borrowed.enumerated() {
            do {
                let book = try libraryService.getBook(bookId: issued.bookId)
                
                print("\(index + 1). ", terminator: "")
                consolePrinter.printBookDetails(book)
                
                print(
                    " Due: \(issued.dueDate.formatted) \(issued.isOverdue ? "OVERDUE" : "")"
                )
            } catch {
                consolePrinter.showError(error.localizedDescription)
            }
        }
        
        guard
            let index = InputUtils.readValidIndex(
                from: borrowed.count,
                prompt:
                    "Enter book number to request (or press Enter to cancel)"
            )
        else {
            return nil
        }

        return borrowed[index]
        
    }
    
    enum UserMenuOption: String, CaseIterable {
        case searchBooks = "Search Books"
        case viewAvailableBooks = "View All Available Books"
        case viewMyBorrowedBooks = "View My Borrowed Books"
        case requestBorrow = "Request to Borrow a Book"
        case renewBook = "Renew the Borrowed Book"
        case returnBook = "Return a Book"
        case borrowRequestHistory = "View BorrowRequest History"
        case viewProfile = "View Profile"
        case updateProfile = "Update Profile"
        case logout = "Logout"
    }
    
}
