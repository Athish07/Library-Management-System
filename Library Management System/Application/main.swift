struct LibraryApp {
    
    static func main() {
        
        let bookRepo: BookRepository = InMemoryBookRepository()
        let userRepo: UserRepository = InMemoryUserRepository()
        let requestRepo: BorrowRequestRepository = InMemoryBorrowRequestRepository()
        let issuedRepo: IssuedBookRepository = InMemoryIssuedBookRepository()
        
        let authenticationService: AuthenticationService = AuthenticationManager(userRepository: userRepo)
        let libraryService: LibraryService = LibraryManager(
            bookRepository: bookRepo,
            borrowRequestRepository: requestRepo,
            issuedBookRepository: issuedRepo
        )
        
        authenticationService.seedDemoDetails(userRepository: userRepo)
        libraryService.seedBookData()
        
        let appController = AppController(authenticationService: authenticationService, libraryService: libraryService)
        
        appController.start()
    }
    
}

