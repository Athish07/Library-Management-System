import Foundation

final class AppController {

    typealias MenuOption = PublicMenu

    private let authenticationService: AuthenticationService
    private let libraryService: LibraryService
    private let userService: UserService
    private let reportService: ReportService
    private let consolePrinter: ConsolePrinter

    init(
        authenticationService: AuthenticationService,
        libraryService: LibraryService,
        userService: UserService,
        consolePrinter: ConsolePrinter,
        reportService: ReportService
    ) {
        self.authenticationService = authenticationService
        self.libraryService = libraryService
        self.userService = userService
        self.reportService = reportService
        self.consolePrinter = consolePrinter
    }

    func start() {

        while true {

            consolePrinter.showMenu(
                PublicMenu.allCases,
                title: "LIBRARY MANAGEMENT SYSTEM"
            )

            guard
                let choice = InputUtils.readMenuChoice(
                    from: PublicMenu.allCases
                )
            else {
                consolePrinter.showError("Invalid choice")
                continue
            }

            switch choice {
            case .login:
                showLoginRoleMenu()
            case .register:
                register()
            case .exit:
                print("Thank you for using the Library System. Goodbye!")
                exit(0)
            }
        }
    }

    private func showLoginRoleMenu() {
        consolePrinter.showMenu(UserRole.allCases, title: "Login As")

        guard
            let choice = InputUtils.readMenuChoice(
                from: UserRole.allCases,
                prompt: "Enter your choice(press ENTER to move back)"
            )
        else {
            return
        }

        switch choice {
        case .librarian:
            login(as: .librarian)
        case .user:
            login(as: .user)
        }
    }

    private func login(as role: UserRole) {
        print("=== \(role == .librarian ? "Librarian" : "User") Login ===")

        let email = InputUtils.readEmail("Enter email")
        let password = InputUtils.readPassword("Enter Password")

        do {
            let user = try authenticationService.login(
                email: email,
                password: password,
                role: role
            )

            print("Login successful! Welcome, \(user.name).")

            switch role {
            case .librarian:
                LibrarianController(
                    currentUserId: user.userId,
                    libraryService: libraryService,
                    userService: userService,
                    reportService: reportService,
                    consolePrinter: consolePrinter
                ).start()

            case .user:
                UserController(
                    currentUserId: user.userId,
                    libraryService: libraryService,
                    userService: userService,
                    consolePrinter: consolePrinter
                ).start()
            }

        } catch {
            consolePrinter.showError(error.localizedDescription)

        }
    }

    private func register() {

        print("=== Register New User ===")

        let name = InputUtils.readString("Enter full name")
        let email = InputUtils.readEmail("Enter email")
        let password = InputUtils.readPassword("Enter password")
        let confirm = InputUtils.readPassword("Confirm password")

        guard password == confirm else {
            consolePrinter.showError("Passwords do not match.")
            return
        }

        let phone = InputUtils.readPhoneNumber("Enter phone number")
        let address = InputUtils.readString("Enter address")

        do {
            try authenticationService.register(
                name: name,
                email: email,
                password: password,
                phoneNumber: phone,
                address: address
            )

            print(
                "Registration successful!\nYou can now login with your credentials."
            )

        } catch {
            consolePrinter.showError(error.localizedDescription)
        }
    }
}

extension AppController {

    enum PublicMenu: String, CaseIterable {
        case login = "Login"
        case register = "Register"
        case exit = "Exit"

    }
}
