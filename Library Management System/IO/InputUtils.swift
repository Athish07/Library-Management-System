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
                input.isValidEmail ? input : nil
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
                input.isValidPhoneNumber ? input : nil
            }
        ) ?? ""
    }
    
    static func readPassword(
        _ prompt: String = "Password"
    ) -> String {

        while true {
            print(prompt, terminator: ": ")

            let input = String(cString: getpass(""))
            print()

            let trimmed = input.trimmingCharacters(
                in: .whitespacesAndNewlines
            )

            if trimmed.isValidPassword {
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

