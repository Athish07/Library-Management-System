import Foundation

extension String {
    
    var emailValidation: Bool {
        let pattern =
            #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#

        if range(of: pattern, options: .regularExpression) != nil {
            return true
        }
        return false
    }

    var phoneValidation: Bool {
        let pattern = #"^[0-9]{10}$"#

        if range(of: pattern, options: .regularExpression) != nil {
            return true
        }
        return false
    }

    var passwordValidation: Bool {
        let pattern =
            #"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$"#

        if range(of: pattern, options: .regularExpression) != nil {
            return true
        }
        
        return false
    }
}
