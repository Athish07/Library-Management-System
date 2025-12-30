let bookRepository: BookRepository = InMemoryBookRepository()
let userRepository: UserRepository = InMemoryUserRepository()
let requestRepository: BorrowRequestRepository =
    InMemoryBorrowRequestRepository()
let issuedRepository: IssuedBookRepository = InMemoryIssuedBookRepository()

let authenticationService: AuthenticationService =
    AuthenticationManager(userRepository: userRepository)
let libraryService: LibraryService = LibraryManager(
    bookRepository: bookRepository,
    borrowRequestRepository: requestRepository,
    issuedBookRepository: issuedRepository
)

let userService = UserManager(userRepository: userRepository)

authenticationService.seedDemoDetails(userRepository: userRepository)
libraryService.seedBookData()

let appController = AppController(
    authenticationService: authenticationService,
    libraryService: libraryService,
    userService: userService
)
appController.start()
