import Foundation

protocol AuthenticationService {
    func login(email: String, password: String) throws -> UUID?
    
}
