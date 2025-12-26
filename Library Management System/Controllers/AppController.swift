import Foundation

class AppController {

    private let authenticationManager: AuthenticationService
    private let consoleView: ConsoleView

    init(authenticationService: AuthenticationService, consoleView: ConsoleView)
    {
        self.authenticationManager = authenticationService
        self.consoleView = consoleView
    }

    private func start() {

        while true {
            showPublicMenu()
        }
    }

    private func showPublicMenu() {

        let publicMenu = PublicMenu.allCases
        consoleView.showMenu(publicMenu, title: "Public Menu")

        guard let choice = consoleView.readMenuOption() else {
            return
        }

        switch publicMenu[choice - 1] {
        case .login: login()
        case .register: register()
        case .exit: exit(0)
        }
    }

    private func login() {

        let userRoles = UserRole.allCases
        consoleView.showMenu(userRoles, title: "Login")

        guard let choice = consoleView.readMenuOption() else {
            return
        }

        switch userRoles[choice - 1] {

        }

    }

    private func register() {

    }

}
