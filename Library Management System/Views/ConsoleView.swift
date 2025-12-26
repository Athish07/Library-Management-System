struct ConsoleView {

    func showMenu<T: RawRepresentable>(
        _ options: [T],
        title: String
    ) where T.RawValue == String {

        print(title)
        for (index, option) in options.enumerated() {
            print("\(index + 1). \(option.rawValue)")
        }

    }

    func readMenuOption() -> Int? {
        let input = InputUtils.readInt(
            prompt: "Enter your choice (-1 to go back)"
        )
        return input == -1 ? nil : input
    }

    func showMessage(_ message: String) {
        print(message)
    }
}
