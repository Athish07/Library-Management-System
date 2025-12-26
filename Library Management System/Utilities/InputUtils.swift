import Foundation

struct InputUtils {

    static func readInt(prompt: String) -> Int {
        
        while true {
            print(prompt, terminator: ": ")
            
            if let input = readLine(),
                let value = Int(input)
            {
                return value
            }
            print("Invalid Input, Please Enter a valid number.")

        }

    }

    static func readNonEmptyString(_ prompt: String) -> String {

        while true {
            print(prompt, terminator: ": ")

            if let input = readLine(),
                !input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            {
                return input
            }
            print("This field cannot be empty.")

        }
    }

}
