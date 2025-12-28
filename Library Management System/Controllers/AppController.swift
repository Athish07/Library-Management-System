import Foundation
final class AppController {
    
    private let authenticationManager: AuthenticationService
    private let consoleView = ConsoleView()
    
    init(authenticationManager: AuthenticationService) {
        self.authenticationManager = authenticationManager
    }
    
    func start() {
        while true {
            showPublicMenu()
        }
    }
    
    private func showPublicMenu() {
        consoleView.showMenu(PublicMenu.allCases, title: "LIBRARY MANAGEMENT SYSTEM")
        
        guard let choice = InputUtils.readMenuChoice(from: PublicMenu.allCases) else {
            consoleView.showError("Invalid choice")
            return
        }
        
        switch choice {
        case .login:
            showLoginRoleMenu()
        case .register:
            register()
        case .exit:
            consoleView.showMessage("Thank you for using the Library System. Goodbye!")
            exit(0)
        }
    }
    
    private func showLoginRoleMenu() {
        consoleView.showMenu(LoginRoleMenu.allCases, title: "Login As")
        
        guard let choice = InputUtils.readMenuChoice(from: LoginRoleMenu.allCases) else {
            return
        }
        
        switch choice {
        case .librarian:
            login(as: .librarian)
        case .user:
            login(as: .user)
        case .back:
            return
        }
    }
    
    private func login(as role: UserRole) {
        consoleView.showMessage("=== \(role == .librarian ? "Librarian" : "User") Login ===")
        
        let email = InputUtils.readString("Enter email")
        let password = InputUtils.readPassword()
        
        do {
            let user = try authenticationManager.login(email: email, password: password)
            
            guard user.role == role else {
                consoleView.showError("You don't have permission to login as \(role.rawValue).")
                consoleView.waitForEnter()
                return
            }
            
            consoleView.showMessage("Login successful! Welcome, \(user.name).")
            consoleView.waitForEnter()
            
            // TODO: Transition to appropriate menu
            // e.g., UserMenuController(user: user).start()
            
        } catch {
            consoleView.showError("Login failed: \(error.localizedDescription)")
            consoleView.waitForEnter()
        }
    }
    
    private func register() {
       
        consoleView.showMessage("=== Register New User ===")
        
        let name = InputUtils.readString("Enter full name")
        let email = InputUtils.readString("Enter email")
        let password = InputUtils.readPassword("Enter password")
        let confirm = InputUtils.readPassword("Confirm password")
        
        guard password == confirm else {
            consoleView.showError("Passwords do not match.")
            consoleView.waitForEnter()
            return
        }
        
        let phone = InputUtils.readString("Enter phone number")
        let address = InputUtils.readString("Enter address")
        
        do {
            try authenticationManager.register(
                name: name,
                email: email,
                password: password,
                phoneNumber: phone,
                address: address,
                role: .user  // Only users can register
            )
            
            consoleView.showMessage("Registration successful!\nYou can now login with your credentials.")
            consoleView.waitForEnter()
            
        } catch {
            consoleView.showError("Registration failed: \(error.localizedDescription)")
            consoleView.waitForEnter()
        }
    }
}
