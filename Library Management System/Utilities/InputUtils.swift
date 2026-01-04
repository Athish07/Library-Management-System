import Foundation

struct InputUtils {

    private static func read<T>(
        prompt: String,
        allowCancel: Bool,
        validation: (String) -> (T?, String?)
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

            let (value, errorMessage) = validation(trimmed)

            if let value = value {
                return value
            }

            if let error = errorMessage {
                print("\n\(error)\n")
            } else {
                print("Invalid input. Please try again.\n")
            }
        }
    }

    static func readInt(
        _ prompt: String,
        allowCancel: Bool = true
    ) -> Int? {
        read(
            prompt: prompt,
            allowCancel: allowCancel,
            validation: { input in
                if let int = Int(input) {
                    return (int, nil)
                }
                return (nil, "Please enter a valid number.")
            }
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
                if allowEmpty || !input.isEmpty {
                    return (input, nil)
                }
                return (nil, "This field cannot be empty.")
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
                switch input.emailValidation {
                case .valid: return (input, nil)
                case .invalid(let reason): return (nil, reason)
                }
            }
        ) ?? ""
    }

    static func readPhoneNumber(
        _ prompt: String,
        allowEmpty: Bool = false
    ) -> String {
        read(
            prompt: prompt,
            allowCancel: allowEmpty,
            validation: { input in
                switch input.phoneValidation {
                case .valid:
                    return (input, nil)
                case .invalid(let reason):
                    return (nil, reason)
                }
            }
        ) ?? ""
    }

    static func readPassword(
        _ prompt: String
    ) -> String {
        read(prompt: prompt, allowCancel: false) { input in
            switch input.passwordValidation {
            case .valid:
                return (input, nil)
            case .invalid(let reason):
                return (nil, reason)
            }
        } ?? ""
    }

    static func readValidIndex(
        from count: Int,
        prompt: String
    ) -> Int? {

        while true {

            guard let input = InputUtils.readInt(prompt, allowCancel: true)
            else {
                print("Operation cancelled.")
                return nil
            }

            guard (1...count).contains(input) else {
                print("Invalid choice. Please enter a valid number")
                continue
            }

            return input - 1
        }
    }
    
    static func readMenuChoice<T>(
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
