let bookRepository: BookRepository = InMemoryBookRepository()
let userRepository: UserRepository = InMemoryUserRepository()
let borrowrequestRepository: BorrowRequestRepository =
    InMemoryBorrowRequestRepository()
let issuedBookRepository: IssuedBookRepository = InMemoryIssuedBookRepository()
let bookInventoryRepository: BookInventoryRepository =
    InMemoryBookInventoryRepository()

let authenticationService: AuthenticationService =
    AuthenticationManager(userRepository: userRepository)
let libraryService: LibraryService = LibraryManager(
    bookRepository: bookRepository,
    borrowRequestRepository: borrowrequestRepository,
    issuedBookRepository: issuedBookRepository,
    bookInventoryRepository: bookInventoryRepository
)

let reportService: ReportService = ReportManager(
    userRepository: userRepository,
    bookRepository: bookRepository,
    issuedBookRepository: issuedBookRepository,
    borrowRequestRepository: borrowrequestRepository
)

let userService = UserManager(userRepository: userRepository)

DatabaseSeeder.seedIfNeeded(
    userRepository: userRepository,
    bookRepository: bookRepository,
    bookInventoryRepository: bookInventoryRepository
)

let appController = AppController(
    authenticationService: authenticationService,
    libraryService: libraryService,
    userService: userService,
    reportService: reportService
)
appController.start()
