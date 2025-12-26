enum UserRole: String, CaseIterable, MenuItem {
    case user = "User"
    case librarian = "Librarian"
    
    var displayTitle: String {
        rawValue
    }
}
