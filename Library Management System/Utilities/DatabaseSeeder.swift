import Foundation

struct DatabaseSeeder {

    static func seedIfNeeded(
        userRepository: UserRepository,
        librarianRepository: LibrarianRepository,
        bookRepository: BookRepository,
        bookInventoryRepository: BookInventoryRepository
    ) {
        seedDemoUsers(userRepository, librarianRepository)
        seedDemoBooks(bookRepository, bookInventoryRepository)
    }

    private static func seedDemoUsers(_ userRepository: UserRepository, _ librarianRepository: LibrarianRepository) {
        
        if librarianRepository.findByEmail("librarian@gmail.com") == nil  {
            let librarian = Librarian(
                name: "Head Librarian",
                email: "librarian@gmail.com",
                password: "Athish_07",
                phoneNumber: "8148847642",
                address: "Main Library Building",
            )
            librarianRepository.save(librarian)
        }

        if userRepository.findByEmail("user@gmail.com") == nil {
            let testUser = User(
                name: "Test User",
                email: "user@gmail.com",
                password: "Athish_07",
                phoneNumber: "7904411578",
                address: "123 Test Street",
            )
            userRepository.save(testUser)
        }
    }

    private static func seedDemoBooks(
        _ bookRepository: BookRepository,
        _ bookInventoryRepository: BookInventoryRepository
    ) {
        guard bookRepository.getAllBooks().isEmpty else { return }

        let demoBooks: [(Book, Int)] = [

            (
                Book(
                    title: "Swift Programming: The Big Nerd Ranch Guide",
                    author: "Mikey Ward",
                    category: .programming
                ),
                5
            ),

            (
                Book(
                    title: "Clean Architecture",
                    author: "Robert C. Martin",
                    category: .programming
                ),
                3
            ),

            (
                Book(
                    title: "The Pragmatic Programmer",
                    author: "David Thomas",
                    category: .programming
                ),
                4
            ),

            (
                Book(
                    title: "1984",
                    author: "George Orwell",
                    category: .fiction
                ),
                6
            ),

            (
                Book(
                    title: "To Kill a Mockingbird",
                    author: "Harper Lee",
                    category: .fiction
                ),
                4
            ),

            (
                Book(
                    title: "Sapiens",
                    author: "Yuval Noah Harari",
                    category: .history
                ),
                3
            ),

            (
                Book(
                    title: "Cosmos",
                    author: "Carl Sagan",
                    category: .science
                ),
                2
            ),
        ]

        for (book, copies) in demoBooks {
            bookRepository.save(book)
            
            let inventory = BookInventory(
                bookId: book.id,
                totalCopies: copies
            )
            bookInventoryRepository.save(inventory)
        }
    }

}
