let authManager = AuthenticationManager(userRepository: InMemoryUserRepository())
let app = AppController(authenticationManager: authManager)
app.start()
