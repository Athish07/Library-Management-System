import Foundation

struct InputUtils {
    
    private static func read(
        prompt: String
    ) -> String {
        
        print(prompt, terminator: ": ")
        let rawInput = readLine()
        
        return rawInput?.trimmingCharacters(
            in: .whitespacesAndNewlines
        ) ?? ""
        
    }
    
    static func readInt(
        _ prompt: String,
        allowEmpty: Bool = true
    ) -> Int? {
        
        while true {
            
            let input = read(prompt: prompt)
            
            if input.isEmpty, allowEmpty {
                return nil
            }
            
            if let number = Int(input) {
                return number
            }
            
            print("Invalid integer value. Please try again.")
        }
    }
    
    static func readString(
        _ prompt: String,
        allowEmpty: Bool = false
    ) -> String {

        while true {
            
            let input = read(prompt: prompt)
            
            if input.isEmpty, !allowEmpty {
                print("Input cannot be empty. Please try again.")
                continue
            }
            
            return input
        }
    }
    
    static func readEmail(
        _ prompt: String,
        allowEmpty: Bool = false
    ) -> String {
        
        while true {
            
            let input = read(prompt: prompt)
            
            if (input.isEmpty && allowEmpty) || input.emailValidation {
                return input
            }
            print("Invalid Email format")
        }
        
    }
    
    static func readPhoneNumber(
        _ prompt: String,
        allowEmpty: Bool = false
    ) -> String {
        
        while true {
            
            let input = read(prompt: prompt)
            
            if (input.isEmpty && allowEmpty) || input.phoneValidation {
                return input
            }
            
            print("Invalid PhoneNumber")
        }
    }
    
    static func readPassword(
        _ prompt: String,
        allowEmpty: Bool = false
    ) -> String {
        
        while true {

            let input = read(prompt: prompt)

            if (input.isEmpty && allowEmpty) || input.passwordValidation {
                return input
            }

            print(
                """
                Password must contain:
                • At least 8 characters
                • One uppercase letter
                • One lowercase letter
                • One number
                """
        
            )
        }
        
    }
    
    static func readMenuChoice<T>(
        from options: [T],
        prompt: String = "Enter your choice"
    ) -> T? {
        
        guard !options.isEmpty else {
            return nil
        }
        
        let max = options.count
        
        while true {
            
            guard let index = readInt(prompt, allowEmpty: true) else {
                return nil
            }
            
            if (1...max).contains(index) {
                return options[index - 1]
            }
            
            print("Invalid choice. Please try again.\n")
        }
    }
}
