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
    
    static func readPassword(_ prompt: String = "Password") -> String {
        print(prompt, terminator: ": ")
        
        let input = String(cString: getpass(""))
        print()
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? readPassword(prompt) : trimmed
    }
    
    static func readMenuChoice<T: CaseIterable & RawRepresentable>(
        from options: [T],
        prompt: String = "Enter your choice"
    ) -> T? {
        
        let max = options.count
        
        while true {
            guard let index = readInt("\(prompt) (1–\(max), or press Enter to go back)", allowCancel: true),
                  index >= 1 && index <= max else {
                return nil
            }
            return options[index - 1]
        }
    }
}
