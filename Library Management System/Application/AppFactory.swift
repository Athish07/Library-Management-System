//import Foundation
//
//final class AppFactory {
//
//    private let bookRepository = InMemoryBookRepository()
//    private let borrowRequestRepository = InMemoryBorrowRequestRepository()
//    private let issuedBookRepository = InMemoryIssuedBookRepository()
//    private let userRepository = InMemoryUserRepository()
//    private let librarianRepository: LibrarianRepository
//    private let authenticationService: AuthenticationService
//
//    init() {
//
//        let defaultLibrarian = Librarian(
//            librarianId: UUID(),
//            name: "Librarian",
//            email: "librarian@gmail.com",
//            password: "athish",
//            phoneNumber: "8148847642",
//            address: "Chennai"
//        )
//
//        self.librarianRepository = InMemoryLibrarianRepository(defaultLibrarian)
//
//        self.authenticationService = AuthenticationManager(
//            userRepository: userRepository,
//            librarianRepository: librarianRepository
//        )
//    }
//}
