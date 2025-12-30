import Foundation

extension String {

    var isValidEmail: Bool {
        let pattern =
        #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#

        return range(of: pattern, options: .regularExpression) != nil
    }

    var isValidPhoneNumber: Bool {
        let pattern = #"^[0-9]{10}$"#
        return range(of: pattern, options: .regularExpression) != nil
    }

    var isValidPassword: Bool {
        let pattern =
        #"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$"#

        return range(of: pattern, options: .regularExpression) != nil
    }
}

