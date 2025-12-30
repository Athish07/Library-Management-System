import Foundation
final class AppController {
    
    private let authenticationService: AuthenticationService
    private let libraryService: LibraryService
    private let userService: UserService
    private let consoleView = ConsoleView()
    
    init(authenticationService: AuthenticationService, libraryService: LibraryService, userService: UserService) {
        self.authenticationService = authenticationService
        self.libraryService = libraryService
        self.userService = userService
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
            print("Thank you for using the Library System. Goodbye!")
            exit(0)
        }
    }
    
    private func showLoginRoleMenu() {
        consoleView.showMenu(UserRole.allCases, title: "Login As")
        
        guard let choice = InputUtils.readMenuChoice(from: UserRole.allCases, prompt: "Enter your choice(press ENTER to move back)") else {
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
        let password = InputUtils.readValidatedPassword()
        
        do {
            let user = try authenticationService.login(email: email, password: password)
            
            guard user.role == role else {
                consoleView.showError("You don't have permission to login as \(role.rawValue).")
                
                return
            }
            
            print("Login successful! Welcome, \(user.name).")
           
            
            switch role {
                    case .librarian:
                        LibrarianController(
                            currentUserId: user.userId,
                            libraryService: libraryService,
                            userService: userService
                        ).start()

                    case .user:
                        UserController(
                            currentUserId: user.userId,
                            libraryService: libraryService,
                            userService: userService
                        ).start()
                    }
            
        } catch {
            consoleView.showError("Login failed: \(error.localizedDescription)")
           
        }
    }
    
    private func register() {
       
         print("=== Register New User ===")
        
        let name = InputUtils.readString("Enter full name")
        let email = InputUtils.readEmail("Enter email")
        let password = InputUtils.readValidatedPassword("Enter password")
        let confirm = InputUtils.readValidatedPassword("Confirm password")
        
        guard password == confirm else {
            consoleView.showError("Passwords do not match.")
            return
        }
        
        let phone = InputUtils.readString("Enter phone number")
        let address = InputUtils.readString("Enter address")
        
        do {
            try authenticationService.register(
                name: name,
                email: email,
                password: password,
                phoneNumber: phone,
                address: address,
                role: .user  
            )
            
            print("Registration successful!\nYou can now login with your credentials.")
            
        } catch {
            consoleView.showError("Registration failed: \(error.localizedDescription)")
        }
    }
}
