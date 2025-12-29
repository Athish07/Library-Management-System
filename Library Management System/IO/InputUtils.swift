import Foundation

struct InputUtils {
    
    private static func read<T>(
        prompt: String,
        cancelValue: T? = nil,
        validation: (String) -> T?
    ) -> T? {
        while true {
            print(prompt, terminator: ": ")
            
            guard let rawInput = readLine() else { continue }
            
            let trimmed = rawInput.trimmingCharacters(in: .whitespacesAndNewlines)
            
           
            if trimmed.isEmpty, cancelValue != nil {
                return cancelValue
            }
            
            if let result = validation(trimmed) {
                return result
            }
            
            print("Invalid input. Please try again.\n")
        }
    }
    
    static func readInt(_ prompt: String, allowCancel: Bool = true) -> Int? {
        read(
            prompt: prompt,
            cancelValue: allowCancel ? -1 : nil
        ) { Int($0) }
    }
    
    static func readString(_ prompt: String, allowEmpty: Bool = false) -> String {
        read(
            prompt: prompt,
            cancelValue: allowEmpty ? "" : nil
        ) { input in
            allowEmpty || !input.isEmpty ? input : nil
        }!
    }
    
    static func readEmail(_ prompt: String) -> String {
        read(prompt: prompt) { input in
            isValidEmail(input) ? input : nil
        }!
    }

    private static func isValidEmail(_ email: String) -> Bool {
        let pattern =
        #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#

        return email.range(
            of: pattern,
            options: .regularExpression
        ) != nil
    }
    
    static func readPhoneNumber(_ prompt: String) -> String {
        read(prompt: prompt) { input in
            isValidPhoneNumber(input) ? input : nil
        }!
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
           print(prompt, terminator: ": ")

           let input = String(cString: getpass(""))
           print()

           let trimmed = input.trimmingCharacters(
               in: .whitespacesAndNewlines
           )

           guard isValidPassword(trimmed) else {
               print("""
               Password must contain:
                -> At least 8 characters
                -> One uppercase letter
                -> One lowercase letter
                -> One number
               """)
               return readValidatedPassword(prompt)
           }

           return trimmed
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
            guard let index = readInt("\(prompt)", allowCancel: true),
                  index >= 1 && index <= max else {
                return nil
            }
            return options[index - 1]
        }
    }
}
