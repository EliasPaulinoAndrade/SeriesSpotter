import Foundation

struct MockError: Error, Equatable {
    let id = UUID().uuidString
}
