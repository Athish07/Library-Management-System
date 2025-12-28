import Foundation

final class ConsoleView {

    func showMenu<T: CaseIterable & RawRepresentable>(
        _ options: [T],
        title: String
    ) {

        print("=== \(title) ===\n")
        
        for (index, option) in options.enumerated() {
            print("\(index + 1). \(option.rawValue)")
        }
    }

    func showMessage(_ message: String) {
        print("\n\(message)\n")
    }

    func showError(_ message: String) {
        print("\n\(message)\n")
    }

    func waitForEnter() {
        print("Press Enter to continue...")
        _ = readLine()
    }

}
