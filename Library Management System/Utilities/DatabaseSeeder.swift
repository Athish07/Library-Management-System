import Foundation

struct DatabaseSeeder {

    static func seedIfNeeded(
        userRepository: UserRepository,
        bookRepository: BookRepository
    ) {
        seedDemoUsers(using: userRepository)
        seedDemoBooks(using: bookRepository)
    }

    private static func seedDemoUsers(using userRepository: UserRepository) {
        if userRepository.findByEmail("athish@gmail.com") == nil {
            let librarian = User(
                name: "Head Librarian",
                email: "athish@gmail.com",
                password: "Athish_07",
                phoneNumber: "8148847642",
                address: "Main Library Building",
                role: .librarian
            )
            userRepository.save(librarian)
        }

        if userRepository.findByEmail("user@gmail.com") == nil {
            let testUser = User(
                name: "Test User",
                email: "user@gmail.com",
                password: "Athish_07",
                phoneNumber: "7904411578",
                address: "123 Test Street",
                role: .user
            )
            userRepository.save(testUser)
        }
    }

    private static func seedDemoBooks(using bookRepository: BookRepository) {
        guard bookRepository.getAllBooks().isEmpty else { return }

        let demoBooks = [
            Book(
                title: "Swift Programming: The Big Nerd Ranch Guide",
                author: "Mikey Ward",
                category: .programming,
                totalCopies: 5
            ),

            Book(
                title: "Clean Architecture",
                author: "Robert C. Martin",
                category: .programming,
                totalCopies: 3
            ),

            Book(
                title: "The Pragmatic Programmer",
                author: "David Thomas",
                category: .programming,
                totalCopies: 4
            ),

            Book(
                title: "1984",
                author: "George Orwell",
                category: .fiction,
                totalCopies: 6
            ),

            Book(
                title: "To Kill a Mockingbird",
                author: "Harper Lee",
                category: .fiction,
                totalCopies: 4
            ),

            Book(
                title: "Sapiens",
                author: "Yuval Noah Harari",
                category: .history,
                totalCopies: 3
            ),

            Book(
                title: "Cosmos",
                author: "Carl Sagan",
                category: .science,
                totalCopies: 2
            ),
        ]

        for book in demoBooks {
            bookRepository.save(book)
        }
    }
}
