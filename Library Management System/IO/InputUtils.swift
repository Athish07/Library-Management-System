import Foundation

struct InputUtils {
    
    private static func read<T>(
        prompt: String,
        allowCancel: Bool,
        validation: (String) -> T?
    ) -> T? {

        while true {
            print(prompt, terminator: ": ")

            guard let rawInput = readLine() else {
                continue
            }

            let trimmed = rawInput.trimmingCharacters(
                in: .whitespacesAndNewlines
            )
            
            if trimmed.isEmpty, allowCancel {
                return nil
            }
            
            if let value = validation(trimmed) {
                return value
            }

            print("Invalid input. Please try again.\n")
        }
    }
    
    static func readInt(
        _ prompt: String,
        allowCancel: Bool = true
    ) -> Int? {
        read(
            prompt: prompt,
            allowCancel: allowCancel,
            validation: { Int($0) }
        )
    }

    static func readString(
        _ prompt: String,
        allowEmpty: Bool = false
    ) -> String {
        read(
            prompt: prompt,
            allowCancel: allowEmpty,
            validation: { input in
                allowEmpty || !input.isEmpty ? input : nil
            }
        ) ?? ""
    }
    
    static func readEmail(
        _ prompt: String,
        allowEmpty: Bool = false
    ) -> String {
        read(
            prompt: prompt,
            allowCancel: allowEmpty,
            validation: { input in
                isValidEmail(input) ? input : nil
            }
        ) ?? ""
    }

    private static func isValidEmail(_ email: String) -> Bool {
        let pattern =
            #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#

        return email.range(
            of: pattern,
            options: .regularExpression
        ) != nil
    }
    
    static func readPhoneNumber(
        _ prompt: String,
        allowEmpty: Bool = false
    ) -> String {
        read(
            prompt: prompt,
            allowCancel: allowEmpty,
            validation: { input in
                isValidPhoneNumber(input) ? input : nil
            }
        ) ?? ""
    }

    private static func isValidPhoneNumber(_ phone: String) -> Bool {
        let pattern = #"^[0-9]{10}$"#
        return phone.range(
            of: pattern,
            options: .regularExpression
        ) != nil
    }
    
    static func readValidatedPassword(
        _ prompt: String = "Password"
    ) -> String {

        while true {
            print(prompt, terminator: ": ")

            let input = String(cString: getpass(""))
            print()

            let trimmed = input.trimmingCharacters(
                in: .whitespacesAndNewlines
            )

            if isValidPassword(trimmed) {
                return trimmed
            }

            print("""
            Password must contain:
             -> At least 8 characters
             -> One uppercase letter
             -> One lowercase letter
             -> One number
            """)
        }
    }

    private static func isValidPassword(_ password: String) -> Bool {
        let pattern =
            #"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$"#

        return password.range(
            of: pattern,
            options: .regularExpression
        ) != nil
    }
    
    static func readMenuChoice<T: CaseIterable & RawRepresentable>(
        from options: [T],
        prompt: String = "Enter your choice"
    ) -> T? {

        let max = options.count

        while true {
            guard let index = readInt(prompt, allowCancel: true) else {
                return nil
            }

            if (1...max).contains(index) {
                return options[index - 1]
            }

            print("Invalid choice. Please try again.\n")
        }
    }
}

