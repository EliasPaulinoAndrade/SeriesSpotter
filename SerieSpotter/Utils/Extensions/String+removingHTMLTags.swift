import Foundation

extension String {
    func removingHTMLTags() -> String {
        replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
