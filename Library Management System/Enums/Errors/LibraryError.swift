import Foundation

enum LibraryError: Error, LocalizedError {
    case bookNotFound
    case bookUnavailable
    case duplicateBorrowRequest
    case issueNotFound
    case bookAlreadyReturned
    case invalidReturnDate
    case invalidCopyCount
    case bookCurrentlyIssued
    case requestNotFound
    case requestNotPending

    var errorDescription: String? {
        switch self {
        case .bookNotFound: return "Book not found."
        case .bookUnavailable: return "Book is not available for borrowing."
        case .duplicateBorrowRequest:
            return "You already have a pending request for this book."
        case .issueNotFound: return "Borrow record not found."
        case .bookAlreadyReturned: return "This book has already been returned."
        case .invalidReturnDate:
            return "Return date cannot be before issue date."
        case .invalidCopyCount:
            return "Number of copies must be greater than zero."
        case .bookCurrentlyIssued:
            return "Cannot remove book while copies are issued."
        case .requestNotFound: return "Borrow request not found."
        case .requestNotPending: return "Request is not pending."
        }
    }

}
