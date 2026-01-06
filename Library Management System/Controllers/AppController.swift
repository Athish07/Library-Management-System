import Foundation

final class AppController {

    private let authenticationService: AuthenticationService
    private let libraryService: LibraryService
    private let userService: UserService
    private let reportService: ReportService

    init(
        authenticationService: AuthenticationService,
        libraryService: LibraryService,
        userService: UserService,
        reportService: ReportService
    ) {
        self.authenticationService = authenticationService
        self.libraryService = libraryService
        self.userService = userService
        self.reportService = reportService
    }

    func start() {

        while true {

            OutputUtils.showMenu(
                MainMenu.allCases,
                title: "LIBRARY MANAGEMENT SYSTEM"
            )

            guard
                let choice = InputUtils.readMenuChoice(
                    from: MainMenu.allCases
                )
            else {
                OutputUtils.showError("Invalid choice")
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
        OutputUtils.showMenu(UserRole.allCases, title: "Login As")

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

        let email = InputUtils.readString("Enter email")
        let password = InputUtils.readString("Enter Password")

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
                    currentUserId: user.id,
                    libraryService: libraryService,
                    userService: userService,
                    reportService: reportService
                ).start()

            case .user:
                UserController(
                    currentUserId: user.id,
                    libraryService: libraryService,
                    userService: userService,
                    reportService: reportService
                ).start()
            }

        } catch {
            OutputUtils.showError(error.localizedDescription)

        }
    }

    private func register() {

        print("=== Register New User ===")

        let name = InputUtils.readString("Enter full name")
        let email = InputUtils.readEmail("Enter email")
        let password = InputUtils.readPassword("Enter password")
        let confirm = InputUtils.readPassword("Confirm password")

        guard password == confirm else {
            OutputUtils.showError("Passwords do not match.")
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
            OutputUtils.showError(error.localizedDescription)
        }
    }
}

extension AppController {

    enum MainMenu: String, CaseIterable {
        case login = "Login"
        case register = "Register"
        case exit = "Exit"

    }
}
