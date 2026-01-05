import Foundation

extension String {

    enum ValidationResult {
        case valid
        case invalid(reason: String)
    }

    var emailValidation: ValidationResult {
        let pattern =
            #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        
        if range(of: pattern, options: .regularExpression) != nil {
            return .valid
        }
        return .invalid(reason: "Invalid email format.")
    }

    var phoneValidation: ValidationResult {
        let pattern = #"^[0-9]{10}$"#

        if range(of: pattern, options: .regularExpression) != nil {
            return .valid
        }
        return .invalid(reason: "Phone number must be exactly 10 digits.")
    }

    var passwordValidation: ValidationResult {
        let pattern =
            #"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$"#

        if range(of: pattern, options: .regularExpression) != nil {
            return .valid
        }

        return .invalid(
            reason: """
                Password must contain:
                • At least 8 characters
                • One uppercase letter
                • One lowercase letter
                • One number
                """
        )
    }
}
