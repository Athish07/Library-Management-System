let bookRepository: BookRepository = InMemoryBookRepository()
let userRepository: UserRepository = InMemoryUserRepository()
let borrowrequestRepository: BorrowRequestRepository =
    InMemoryBorrowRequestRepository()
let issuedBookRepository: IssuedBookRepository = InMemoryIssuedBookRepository()

let authenticationService: AuthenticationService =
    AuthenticationManager(userRepository: userRepository)
let libraryService: LibraryService = LibraryManager(
    bookRepository: bookRepository,
    borrowRequestRepository: borrowrequestRepository,
    issuedBookRepository: issuedBookRepository
)

let reportService: ReportService = ReportManager(
    userRepository: userRepository,
    bookRepository: bookRepository,
    issuedBookRepository: issuedBookRepository,
    borrowRequestRepository: borrowrequestRepository
)

let userService = UserManager(userRepository: userRepository)

DatabaseSeeder.seedIfNeeded(userRepository: userRepository, bookRepository: bookRepository)

let appController = AppController(
    authenticationService: authenticationService,
    libraryService: libraryService,
    userService: userService,
    reportService: reportService
)
appController.start()
